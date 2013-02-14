Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391Ab3BNBMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:12:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:20323 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761381Ab3BNBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:12:19 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-8e-511c39f2a8f3
Message-id: <511C39F2.6050802@samsung.com>
Date: Thu, 14 Feb 2013 10:12:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>, kyungmin.park@samsung.com
Subject: Re: [GIT PULL] extcon for 3.9
References: <511C24B7.4000802@samsung.com> <20130213235254.GB19813@kroah.com>
In-reply-to: <20130213235254.GB19813@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zTd1PljKBBjP2cFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MDXu2sBb84arob9rI3MDYyNnFyMkhIWAi8fzZVTYIW0ziwr31
	QDYXh5DAMkaJ/9eb2WCKVl48xgyRWMQo8XrZaiYIp5NJor9hLjtIFa+AlsTpGwvBOlgEVCX2
	zd4OZrMBxfe/uAFmiwqESaycfoUFol5Q4sfke2C2iICGxMujt8BsZoFaiftPQbZxcAgLqEnc
	mFwDEhYS8JWY1PWBESTMKaAvceNUNkS1tcTKSdsYIWx5ic1r3oLdKSHwn02i5+dTZohzBCS+
	TT7EAtIrISArsekAM8RfkhIHV9xgmcAoNgvJQbOQjJ2FZOwCRuZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGCERIb2DcVWDxSFGAQ5GJR5ehV/SgUKsiWXFlbmHGCU4mJVEeB8oyQQK8aYk
	VlalFuXHF5XmpBYfYkwGOnAis5Rocj4wWvNK4g2NDYwNDS0NzUwtTQ1IE1YS52U89SRASCA9
	sSQ1OzW1ILUIZgsTB6dUA6PbkhW/jYIesi8Lfv0yQy4sKfvAvMPTVl94yFQ9rV0q5vCeLyIB
	6c+mfsufbp13aKJLu/2vTJf/FqXXJhU7fN7x+OLq529ENu1MPn2P3bV0/YSV6jNiv0fNlpne
	OG9rkXP0GpaY0Nk/Za9em282/WOK7wn53/Mkbk719JBstHHhmv/w1AWfo+7cSizFGYmGWsxF
	xYkAsBozGswCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAd1PljKBBoemM1lc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjA17trAW/OGq6G/ayNzA
	2MjZxcjJISFgIrHy4jFmCFtM4sK99WxdjFwcQgKLGCVeL1vNBOF0Mkn0N8xlB6niFdCSOH1j
	IRuIzSKgKrFv9nYwmw0ovv/FDTBbVCBMYuX0KywQ9YISPybfA7NFBDQkXh69BWYzC9RK3H8K
	spmDQ1hATeLG5BqQsJCAr8Skrg+MIGFOAX2JG6eyIaqtJVZO2sYIYctLbF7zlnkCo8AsJAtm
	ISmbhaRsASPzKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgeHsmvYNxVYPFIUYBDkYlHl6F
	X9KBQqyJZcWVuYcYJTiYlUR4HyjJBArxpiRWVqUW5ccXleakFh9iTAb6fyKzlGhyPjAV5JXE
	GxqbmBlZGpkZm5gbG5MmrCTOy3jqSYCQQHpiSWp2ampBahHMFiYOTqkGxkCRLxvtkuWYtMu3
	/dx4qvRLm5hZe1zyiZ+5Vx6fqtSZea/E4+7xW4deXN9h7V/YNu/7xBcL9vP/7/C/Hnqm54tz
	XInHyvWC529x/JonIy/i6xiuZ1nZ9ko43DPcZbaRw8Tfxn/XB21b8ejpq206KYaRLSXHFjJa
	LdO3F+xpnzVVJOeLFEvJFSWW4oxEQy3mouJEAAS92x37AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 08:52 AM, Greg KH wrote:
> On Thu, Feb 14, 2013 at 08:41:43AM +0900, Chanwoo Choi wrote:
>> Hi Greg,
>>
>> This pull-reqeust patchset is based on char-misc-next branch(char-misc.git).
>> Please pull extcon with following updates.
>>
>> Best regards,
>> Chanwoo Choi
>>
>> The following changes since commit 19d3243e797c2abc02a214d3cec9fefa5dc048ff:
>>
>>    extcon: max77693: Remove unnecessary goto statement to improve
>> readability (2013-02-13 08:35:44 -0800)
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org:/pub/scm/linux/kernel/git/chanwoo/extcon.git
>> tags/extcon-for-3.9
> $ git pull git://git.kernel.org:/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-for-3.9
> fatal: Unable to look up git.kernel.org (port <none>) (Servname not supported for ai_socktype)
>
> You added an extra ':' in that url, how did you generate it?  Please be
> more careful in the future.
>
> I fixed it by hand...
>
> thanks,
>
> greg k-h
>
Sorry, It is my mistask

When I execute 'git request-pull' command, I use following git 
repository url instead of 'git.kernel.org'.
because firewall policy of company. So, I modify git repository url in 
reqeust-pull text directly.
- gitolite.kernel.org:/pub/scm/linux/kernel/git/chanwoo/extcon.git

I'll be careful and I don't make the same mistake.

Best Regards,
Chanwoo Choi


