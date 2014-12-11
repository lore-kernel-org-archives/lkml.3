Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbaLKDAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:00:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15028 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbaLKDAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:00:06 -0500
X-AuditID: cbfee68d-f79296d000004278-24-548908b1fd43
Message-id: <548908C2.1060906@samsung.com>
Date: Thu, 11 Dec 2014 08:30:18 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        thomas.ab@samsung.com, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/2] soc: samsung: add exynos chipid driver support
References: <1417594658-2931-1-git-send-email-pankaj.dubey@samsung.com>
 <1417594658-2931-2-git-send-email-pankaj.dubey@samsung.com>
 <CAKew6eVTpu0qWQqd_sxqmRJF6qNMxJp5Mn0_ta5vO+pHAv66ug@mail.gmail.com>
In-reply-to: <CAKew6eVTpu0qWQqd_sxqmRJF6qNMxJp5Mn0_ta5vO+pHAv66ug@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWyRsSkTncjR2eIQfM9C4u/k46xWxz4s4PR
	4v+j16wWvQuusllM+bOcyWLT42usFpd3zWGzmHF+H5PF7cu8Fq17j7BbdCxjtFi16w+jxdzf
	jawOvB4tzT1sHr9/TWL02DnrLrvHplWdbB53ru1h89i8pN6jb8sqRo/t1+Yxe3zeJBfAGcVl
	k5Kak1mWWqRvl8CV0dTxg7HgEW/F1G85DYzzuboYOTgkBEwklu8X72LkBDLFJC7cW8/WxcjF
	ISSwlFHi05mnTBAJE4lHHeeYIRKLGCXOXXrODJIQEmhlklja7Ali8wpoSXQc3coKYrMIqEp8
	2rCWHcRmE9CVePJ+Lli9qECExJU1cxgh6gUlfky+xwJiiwgYSExcMo8VZAGzwGQWiY/HP4Al
	hAW8JGZ8WQK1+QyjRF/3XLBuToFgiaaum2DbmAXMJL68PAxly0tsXvMWrEFCYCKHxLG+o2wQ
	JwlIfJt8iAXiZ1mJTQeYIV6TlDi44gbLBEaxWUiOmoVk7CwkYxcwMq9iFE0tSC4oTkovMtQr
	TswtLs1L10vOz93ECIzq0/+e9e5gvH3A+hCjAAejEg9vwOX2ECHWxLLiytxDjKZAV0xklhJN
	zgemjrySeENjMyMLUxNTYyNzSzMlcV5FqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhL
	5myMXnyj79bz00/e6tfcTWnaM+8w43+vD7pimzy2hhUfVp714+vXHZ1RKkZf781REjndzZVy
	ZfLWyVrbyvZX3u5P8K8MTuJsmNie6pkdqM1a/WxtAdP0WmejOblaJ+MsT5oenfpJ6Hja0w3y
	9fdCg84oMcSfO71Aj4Fp9fcLJycqOomJFixVYinOSDTUYi4qTgQA1MTl/uUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd2NHJ0hBn1/DSz+TjrGbnHgzw5G
	i/+PXrNa9C64ymYx5c9yJotNj6+xWlzeNYfNYsb5fUwWty/zWrTuPcJu0bGM0WLVrj+MFnN/
	N7I68Hq0NPewefz+NYnRY+esu+wem1Z1snncubaHzWPzknqPvi2rGD22X5vH7PF5k1wAZ1QD
	o01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0NlKCmWJ
	OaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoymjh+MBY94K6Z+y2lgnM/VxcjJ
	ISFgIvGo4xwzhC0mceHeerYuRi4OIYFFjBLnLj0HSwgJtDJJLG32BLF5BbQkOo5uZQWxWQRU
	JT5tWMsOYrMJ6Eo8eT8XrF5UIELiypo5jBD1ghI/Jt9jAbFFBAwkJi6ZxwqygFlgMovEx+Mf
	wBLCAl4SM74sYYbYfIZRoq97Llg3p0CwRFPXTbBtzAJmEl9eHoay5SU2r3nLPIFRYBaSJbOQ
	lM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDSeCa1g3Flg8UhRgEORiUe3oDL
	7SFCrIllxZW5hxglOJiVRHiTbnSECPGmJFZWpRblxxeV5qQWH2I0BYbBRGYp0eR8YELLK4k3
	NDYxNzU2tTSxMDGzVBLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpgVNXP3Cl0W+OG4L1pZd/Y
	o81f7pctMTi8Vr/c6tDDtU/Tdp1O9H918z3fxLJg55MuR75vYnRcc+KTpf+07KXpsiFrtusm
	z67ZcJxPsK9wj7pB0+KvmmHW94IvZC82lDw3s+Rk+dT1a6RN3a3LNit9Kbt9TqFC4KIy/9Pc
	JWucMqTvtjew5xq8VWIpzkg01GIuKk4EAFDt6RAwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder,

On Thursday 04 December 2014 11:56 PM, Yadwinder Singh Brar wrote:
> Hi Pankaj,
>
>
> On Wed, Dec 3, 2014 at 1:47 PM, Pankaj Dubey <pankaj.dubey@samsung.com
> <mailto:pankaj.dubey@samsung.com>> wrote:
>
>     Exynos SoCs have Chipid, for identification of product IDs
>     and SoC revisions. This patch intendes to provide initialization
>     code for all these functionalites, at the same time it provides some
>     sysfs entries for accessing these information to userspace.
>
>     This driver usese existing binding for exnos-chipid.
>
> [ ... ]
>
>     +
>     +static unsigned int soc_product_id;
>     +static unsigned int soc_revision;
>     +
>     +int exynos_product_id(void)
>     +{
>     +       return soc_product_id;
>     +}
>     +EXPORT_SYMBOL(exynos_product_id);
>     +
>     +int exynos_revision(void)
>     +{
>     +       return soc_revision;
>     +}
>     +EXPORT_SYMBOL(exynos_revision);
>     +
>
>
> How about exporting only a struct containing members : soc_revision,
> soc_product_id

OK, keeping in mind that chipid driver might be used from other drivers 
as well (such as asv) other than from mach-exynos, we can do this.

> and may be some more like asv/fused_info  and keeping these function as

Other members such as fused_info etc. can be added as and when required. 
As of now there is no active user of all those.

> inlines ?
>
>     +static const char *exynos_product_id_to_name(unsigned int product_id)
>
>
> __init ?   hmm .. I think almost whole driver other than __ATTR funcs.
>

OK, I'll take care of this in next patch version.

> Otherwise it looks nice to me :)
>
> Best Regards,
> Yadwinder


Thanks for review.

Pankaj Dubey
