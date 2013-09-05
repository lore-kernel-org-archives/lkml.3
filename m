Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3IEEFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:05:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11585 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3IEEFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:05:22 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-c2-522803006bd1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
 <002201cea9e1$5e99da40$1bcd8ec0$%han@samsung.com>
 <CAK9yfHxR6nfEcCVxviD_=-ffNkcrazM8nWZRTFt2jOJuvaaSjA@mail.gmail.com>
In-reply-to: <CAK9yfHxR6nfEcCVxviD_=-ffNkcrazM8nWZRTFt2jOJuvaaSjA@mail.gmail.com>
Subject: Re: [PATCH 1/6] backlight: lp855x_bl: support new LP8555 device
Date: Thu, 05 Sep 2013 13:05:19 +0900
Message-id: <000601cea9ed$22c19ba0$6844d2e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p5To8hiJfpmarQ3q/1BfhQdECgAAB5TEg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zfV0GZo0gg/Y9ahZz1q9hs5i8u4vV
	4vLCS0Bi1xw2i+W/1rFY7N71lNXi5J9eRgd2j52z7rJ73Lm2h83jxIzfLB575v9g9ejbsorR
	4/iN7UwenzfJBbBHcdmkpOZklqUW6dslcGV8nf+HtWA7e8Waey8ZGxj/sHYxcnJICJhIbLz8
	GMoWk7hwbz1bFyMXh5DAMkaJp1sfAjkcYEWTn0RDxBcxSrTunsII4fxilLh48QEjSDebgJrE
	ly+H2UFsEQEdiRW71jKBFDELvGWUmH5zCgtExw5Gif37DjCDVHEKBEs82P+EBcQWFvCQWNDU
	zARiswioSrQu/Aa2mlfAVmLSpRiQMK+AoMSPyffAypkFtCTW7zzOBGHLS2xe85YZ4lJ1iUd/
	dSFuMJI42HiXGaJERGLfi3dgR0sINHJIXGn/xwqxSkDi2+RDLBC9shKbIC6TEJCUOLjiBssE
	RolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJKb7dzDePWB9
	iDEZaP1EZinR5HxgSsgriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA6OU8inVwqrHB5MYl1gLzlbcaW4sEHiSOfPegqmPM9alry85/b7J56NH+exf
	m2b1nNv785fZTHNd6S5zza1yPX06AbvrhHSlNjbOPqTZnR94oun4p/YPGTkKXKX2Ft08ckZ2
	i8RiJ//J36jy5eXd37//PZFk4Jq646LMZzO+mPPMzEu/TZiYsliJpTgj0VCLuag4EQD+Rncp
	/wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd3/TBpBBpv7rC3mrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKavFyT+9jA7sHjtn3WX3uHNtD5vHiRm/WTz2zP/B6tG3ZRWj
	x/Eb25k8Pm+SC2CPamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVV
	cvEJ0HXLzAG6SEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8XX+H9aC
	7ewVa+69ZGxg/MPaxcjBISFgIjH5SXQXIyeQKSZx4d56ti5GLg4hgUWMEq27pzBCOL8YJS5e
	fMAIUsUmoCbx5cthdhBbREBHYsWutUwgRcwCbxklpt+cwgLRsYNRYv++A8wgVZwCwRIP9j9h
	AbGFBTwkFjQ1M4HYLAKqEq0Lv7GBnMErYCsx6VIMSJhXQFDix+R7YOXMAloS63ceZ4Kw5SU2
	r3nLDHG1usSjv7oQNxhJHGy8ywxRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyM4YTyT3sG4qsHiEKMAB6MSD2+DsXqQEGtiWXFl7iFGCQ5m
	JRFei5VAId6UxMqq1KL8+KLSnNTiQ4zJQH9OZJYSTc4HJrO8knhDYxMzI0sjMwsjE3Nz0oSV
	xHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamC0iH4RL2MU/8CqU2T6k0510ySTetnEa9WK+eYC
	rbP4mYrZWGZ+KmdJ0J46Of/epc9Rvc9qhM9F5Ybd3XBi4SkJxrSPgXOvOH37x9WhdqPsx5vG
	H6fcez0LvgiderPi3d2F21bbGO21ucVarlNtFPDsAOOS39Z/RUwPxse8kL31LrE8Jmr1lA1K
	LMUZiYZazEXFiQDHTb/GXAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 05, 2013 12:09 PM, Sachin Kamat wrote:
> On 5 September 2013 08:11, Jingoo Han <jg1.han@samsung.com> wrote:
> > LP8555 is one of LP855x family device.
> > This device needs pre_init_device() and post_init_device() driver structure.
> > It's same as LP8557, so the device configuration code is shared with LP8557.
> > Backlight outputs are generated from dual DC-DC boost converters.
> > It's configurable EPROM settings which are defined in the platform data.
> >
> > Driver documentation and device tree bindings are updated.
> >
> > Signed-off-by: Milo Kim <milo.kim@ti.com>
> 
> Looks like the author information is lost for this patch and patch 2
> (atleast it does not match
> whatever is mentioned in the cover letter). Please check.

Oh, you're right.
I had to add author's information to 1st patch and 2nd patch.
I will add V2 patchset.
Thank you for your comment. :-)

Best regards,
Jingoo Han

