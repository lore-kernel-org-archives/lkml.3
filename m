Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaIKCOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 22:14:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49011 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaIKCOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 22:14:14 -0400
X-AuditID: cbfee68e-f79536d000000fd1-86-541105731b1d
Message-id: <54110573.3070304@samsung.com>
Date: Thu, 11 Sep 2014 11:14:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Pavel Machek <pavel@denx.de>, Olof Johansson <olof@lixom.net>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?windows-1252?Q?Marek_Va=9Aut?= <marex@denx.de>
Subject: Re: [PATCH] fix mmc hang during boot on socfpga
References: <20140909121902.GA22965@amd>
 <CAOesGMgvqvQw2WzdQWQ7NSE_CKgH0MR-46UABkck0cQbpV4P=g@mail.gmail.com>
 <20140909205618.GA32688@amd>
In-reply-to: <20140909205618.GA32688@amd>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkSLeYVTDE4ORBJYsJl7czWlzeNYfN
	4sj/fkaLN22NjBanrn9mszi6wcXiw/2LzA7sHvNmnWDxuHKiidXjxquFTB59W1YxenzeJBfA
	GsVlk5Kak1mWWqRvl8CV8fTNMeaCJxwVK84fZWxgfMHWxcjJISFgInF3wRdGCFtM4sK99WBx
	IYGljBJT3sjA1Dy9+4kRIj6dUWLDEr8uRi4g+zWjxMHuBrAEr4CWRP/zK8wgNouAqsSr1yvZ
	QWw2AR2J7d+OM4HYogJhEofa5jFB1AtK/Jh8jwXEFhFwlNj06DfYYmaB74wSU2dXgtjCAhYS
	C/cvZ4VY1sco0fDvO9gyTgFNiYMtDUALOIAa9CTuX9SC6JWX2LzmLTPE0afYJb49c4e4R0Di
	2+RDLCDlEgKyEpsOQJVIShxccYNlAqPYLCQXzUIYOgvJ0AWMzKsYRVMLkguKk9KLjPSKE3OL
	S/PS9ZLzczcxAuPt9L9nfTsYbx6wPsQowMGoxMNbwSIYIsSaWFZcmXuI0RToiInMUqLJ+cCo
	ziuJNzQ2M7IwNTE1NjK3NFMS502Q+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXH9u9VK
	mRM2nPvLaCtus39BYZJD0kUjp0zd4plLpKY5Xl7gw1qg/prddpfbzRe34vJTVLVu7fb2uPm+
	dYP51Qm/hB6/43EqYLyiEKutdjlm3omntnnTsxendu3vVaq2Z4xcm24vO6nkE/8P+YItU/0u
	TrdL+C5wP/qp75bv7asWeX1UuKqS063EUpyRaKjFXFScCAA5JLLtsgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd1iVsEQg3mHpC0mXN7OaHF51xw2
	iyP/+xkt3rQ1Mlqcuv6ZzeLoBheLD/cvMjuwe8ybdYLF48qJJlaPG68WMnn0bVnF6PF5k1wA
	a1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoynb44xFzzhqFhx/ihjA+ML
	ti5GTg4JAROJp3c/MULYYhIX7q0HiwsJTGeU2LDEr4uRC8h+zShxsLsBrIhXQEui//kVZhCb
	RUBV4tXrlewgNpuAjsT2b8eZQGxRgTCJQ23zmCDqBSV+TL7HAmKLCDhKbHr0G2wBs8B3Romp
	sytBbGEBC4mF+5ezQizrY5Ro+PcdbBmngKbEwZYGoAUcQA16EvcvakH0yktsXvOWeQKjwCwk
	K2YhVM1CUrWAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBEP5PewbiqweIQowAHoxIP
	byWLYIgQa2JZcWXuIUYJDmYlEd6EBwIhQrwpiZVVqUX58UWlOanFhxhNgQEwkVlKNDkfmGzy
	SuINjU3MjCyNzA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUwCmj5B/44qjXL6WRQ
	qaGbwyG9X6+WxS+WsN7svWlng4GdXo5ql1d8+L22pxaFc05/eKYxp5uxqzR5S7TqrBfOh/vN
	+tIU7AW4H0z6yfvn2cWHD44F2b2ZH/VMQF5/zvuiaJtVsfHBWtqPfjxmcpMV2bLrQrabrMOn
	+c0J/a9nLPH6eS1qlfIuJZbijERDLeai4kQA8cNi5v4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel.

On 09/10/2014 05:56 AM, Pavel Machek wrote:
> On Tue 2014-09-09 10:32:14, Olof Johansson wrote:
>> On Tue, Sep 9, 2014 at 5:19 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>>
>>> Without this patch, boot hangs when trying to mount root filesystem on
>>> socfpga platform in about 50% cases.
>>
>> I think this should have a better description than this -- this is too
>> vague. Did it use to always work, is this a new failure? You enable
>> some more error checking and improved stop handling, why was the
>> previous one inadequate on this platform?
> 
> I don't think it ever worked reliably. I don't know what is different
> for socfpga, or if it is broken on other platforms, too. I have two
> socfpga boards here, but no other dw_mmc board.

I didn't know what error is occurred at your board. But i guess it looks like HLE error, right?
Or you can share how booting is failed. than i think we can discuss more detailedly about your problem.


Best Regards,
Jaehoon Chung

> 
> Patch was separated from rocketboards.org repository.
> 
> Hope this helps,
> 
> 									Pavel
> 

