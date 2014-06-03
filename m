Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaFCA0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:26:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8650 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaFCA0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:26:09 -0400
X-AuditID: cbfee68f-b7fef6d000003970-50-538d1619755f
Message-id: <538D1618.9040107@samsung.com>
Date: Tue, 03 Jun 2014 09:26:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon next-v2 for v3.16
References: <538C06FC.4000009@samsung.com> <20140602225517.GB7641@kroah.com>
 <538D0E86.8080902@samsung.com> <20140603001202.GA17821@kroah.com>
In-reply-to: <20140603001202.GA17821@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkUFdSrDfY4NMVEYvmxevZLM42vWG3
	uLxrDpvF7cYVbA4sHvvnrmH36NuyitHj8ya5AOYoLpuU1JzMstQifbsErox5t/8zFnzlr/g2
	/zBbA+N/ni5GTg4JAROJ7cdvskDYYhIX7q1n62Lk4hASWMoo8ezCEXaYoqbT/xkhEosYJaZt
	aGCBcF4zSvRcWAJWxSugJTH9wTqwUSwCqhJztj9gA7HZgOL7X9wAs0UFwiRWTr/CAlEvKPFj
	8j0wW0RAQ+Ll0VtgQ5kF2hklTh5cAZYQFjCQ2HRmHjPEtgmMEvcP/WcFSXAK6EtcerKICcRm
	FtCR2N86jQ3ClpfYvOYtWIOEwCp2iQ/r9rJBnCQg8W3yIaCpHEAJWYlNB5ghfpOUOLjiBssE
	RrFZSI6ahWTsLCRjFzAyr2IUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjKXT/57172C8e8D6
	EGMy0MqJzFKiyfnAWMwriTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYyhbu+Z81JCufUMFL7067/T4Zz1OKvR4NcM8bmLcn/p3PojfGuZ3hTdFn8X
	CdEVkoqNFha3ih+t1crmVpaZe/BH5+QjrnNn6ojuL/8/J6DdXPydd3RRAreFqkrJyoy6LYwb
	J9bvbZhzoNb/n9kGNfYYW439n/efZnQJWB5SyFhsqs+ZwZ/ppcRSnJFoqMVcVJwIANzDEG67	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xgK6kWG+wwZI3PBbNi9ezWZxtesNu
	cXnXHDaL240r2BxYPPbPXcPu0bdlFaPH501yAcxRDYw2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGENYwZ827/Zyz4yl/xbf5htgbG/zxdjJwcEgImEk2n/zNC2GISF+6tZ+ti5OIQ
	EljEKDFtQwMLhPOaUaLnwhJ2kCpeAS2J6Q/WsYDYLAKqEnO2P2ADsdmA4vtf3ACzRQXCJFZO
	v8ICUS8o8WPyPTBbREBD4uXRW2BDmQXaGSVOHlwBlhAWMJDYdGYeM8S2CYwS9w/9ZwVJcAro
	S1x6sogJxGYW0JHY3zqNDcKWl9i85i3zBEaBWUiWzEJSNgtJ2QJG5lWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwZH6TGoH48oGi0OMAhyMSjy8P/b2BAuxJpYVV+YeYpTgYFYS4TX4BhTi
	TUmsrEotyo8vKs1JLT7EmAwMg4nMUqLJ+cAkklcSb2hsYmZkaWRuaGFkbE6asJI474FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjOYTL/upR4b639Zku7/8U8mbjtgDhRzHN2c9VtN15jku2P/m
	4TKO18XxkmozDma8zBRgYWsM98jrtPx36evdrU2xQr7zZvjVZB14XfbHKkY4xXVSu8JDQ26G
	nZ+8ZNx/XnDx0tKs4NmgEv7KOHDNohUVS5l0J0daKAY8fvDyjdjEsn3VF86kKbEUZyQaajEX
	FScCAFF4rCEYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 09:12 AM, Greg KH wrote:
> On Tue, Jun 03, 2014 at 08:53:42AM +0900, Chanwoo Choi wrote:
>> Dear Greg,
>>
>> On 06/03/2014 07:55 AM, Greg KH wrote:
>>> On Mon, Jun 02, 2014 at 02:09:16PM +0900, Chanwoo Choi wrote:
>>>> Dear Greg,
>>>>
>>>> This is extcon-next-v2 full request for v3.16. This pull request includes
>>>> additional patchset after merged previous extcon-next pull request(tags/extcon-next-for-v3.16).
>>>> I add detailed description of this pull request on below. Please pull extcon with following update.
>>>>
>>>> Best Regards,
>>>> Chanwoo Choi
>>>>
>>>> The following changes since commit 3f79a3fb5f41e8f2229e5bf8aa725eaa79686f14:
>>>>
>>>>   extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev (2014-04-29 09:52:12 +0900)
>>>>
>>>> are available in the git repository at:
>>>>
>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-v2-for-3.16
>>>
>>> I was thinking it was too late for 3.16-rc1, as the merge window is now
>>> open and I like to have things in my tree a week or so before that
>>> happens, but I figured this was nice and self-contained so I would take
>>> it.
>>
>> Sorry late pull-request. I'll send next pull-request before -rc7 release certainly.
>>
>>>
>>> So I pulled, and built, and then got this:
>>>
>>> ERROR: "regmap_irq_get_virq" [drivers/extcon/extcon-sm5502.ko] undefined!
>>> ERROR: "regmap_add_irq_chip" [drivers/extcon/extcon-sm5502.ko] undefined!
>>> ERROR: "regmap_del_irq_chip" [drivers/extcon/extcon-sm5502.ko] undefined!
>>>
>>> which makes me know that you haven't done much build testing of the code
>>> :(
>>
>> Sorry about this mistake. As you comment, I'll check much build testing.
> 
> Any reason your trees are not in linux-next?  I'd recommend them to be
> there, so you can get that build testing ahead-of-time.

As you comment, I'm going to find the way to include extcon patchset for build test
in linux-next.

Best Regards,
Chanwoo Choi











