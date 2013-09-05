Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3IEDwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:52:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9461 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3IEDwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:52:36 -0400
X-AuditID: cbfee68e-b7f756d000004512-2a-522800032c5c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Milo Kim'" <milo.kim@ti.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
 <5227FD07.6040305@ti.com>
In-reply-to: <5227FD07.6040305@ti.com>
Subject: Re: [PATCH 0/6] backlight updates for 3.12-rc1
Date: Thu, 05 Sep 2013 12:52:33 +0900
Message-id: <000501cea9eb$5b053640$110fa2c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p6ZyXEXBbJ9JtSD6KPbP9Jq8gjgAAMyhA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zQ11mBo0gg00PhCzmrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	WxSXTUpqTmZZapG+XQJXxs8/bgVXWCt+/uxhbGBcztLFyMkhIWAisXVZPxuELSZx4d56IJuL
	Q0hgGaPExN7prDBFCz9fg0pMZ5TouvadCcL5xSjxbcV1dpAqNgE1iS9fDoPZIgIKEkefbGQF
	KWIWOMIoMWHyYUaQhJBApMTkjQeYQGxOoIZdi46A3SEsYC4xpfsaWJxFQFViwevdYKt5BWwl
	Gu5/ZoSwBSV+TL4HVs8soCWxfudxJghbXmLzmrfMXYwcQKeqSzz6qwtxg5HE61Uv2SBKRCT2
	vXjHCHKPhMBLdomDp58xQ+wSkPg2+RALRK+sxKYDzBAfS0ocXHGDZQKjxCwkm2ch2TwLyeZZ
	SFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESv307GG8esD7EmAy0fiKzlGhyPjD+
	80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyHql
	r1xl/fnLKqcU5IR6OO/f+xg0e8mxvAviN1fqOEmG7NugdcouofXf9sV8K/ZsPSq7pDTxZe/v
	41esGdoud/0SWeB89/Y/iY+2YjPu5G1qTvfo3ZFQsbrn2RKXlJIJLna288w8fZ+ed///s2vb
	iS3f5s69uDjYm3nZ491GK6dLn9GW27t3Zq0SS3FGoqEWc1FxIgD2PnkZ9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQV1mBo0gg58v+CzmrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	W1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyff9wKrrBW/PzZw9jAuJyl
	i5GTQ0LARGLh52tsELaYxIV764FsLg4hgemMEl3XvjNBOL8YJb6tuM4OUsUmoCbx5cthMFtE
	QEHi6JONrCBFzAJHGCUmTD7MCJIQEoiUmLzxABOIzQnUsGvREbB1wgLmElO6r4HFWQRUJRa8
	3s0KYvMK2Eo03P/MCGELSvyYfA+snllAS2L9zuNMELa8xOY1b5m7GDmATlWXePRXF+IGI4nX
	q16yQZSISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECE4Oz6R2MK5ssDjEKMDBqMTD22CsHiTEmlhWXJl7iFGCg1lJhNdiJVCINyWxsiq1KD++
	qDQntfgQYzLQoxOZpUST84GJK68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakF
	qUUwW5g4OKUaGHOUg2JYrBbkR3fn5jC1TTZvzHpce7nl/Mvle1o/yGgzG6u8qVc6cGHhn5m2
	yWlyf0+ET31Q6Pm0f7pcDZtdW4i38IKJASfX/8u/93r7vaLrfz/wbYjW9GW6efB/Uc5O8Zm5
	u3a26ddJvhOSkYji8E5Z2F4jnG1sF/F+/gafWob4Z/KxG36ZKrEUZyQaajEXFScCAHmQ4HVS	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 05, 2013 12:40 PM, Milo Kim wrote:
> 
> Hi Jingoo,
> 
> On 09/05/2013 11:39 AM, Jingoo Han wrote:
> > Hi Andrew,
> >
> > This is the backlight updates for 3.12-rc1.
> > Please add these patches to mm-tree.
> 
> Do you have a plan to create a git repository for the backlight subsystem?
> It would be much better to maintain it and pull request.
> 
> And mailing-list also. Maybe most guys of kernel mailing list don't care
> the backlight subsystem. ;)
> 

Hi Milo Kim,

I think so.
I will make a git tree and mailing-list for the backlight subsystem later.
However, I am not certain when it will be done. :-(

I really appreciate your advice.

Best regards,
Jingoo Han


