Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3E3Xpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 19:45:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28054 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3E3Xpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 19:45:33 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-3c-51a7e49a232d
Message-id: <51A7E49B.1010704@samsung.com>
Date: Fri, 31 May 2013 08:45:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com, ldewangan@nvidia.com,
        gg@slimlogic.co.uk, lgirdwood@gmail.com, broonie@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        george.cherian@ti.com, sameo@linux.intel.com
Subject: Re: [PATCH 3/3] usb: dwc3: use extcon fwrk to receive
 connect/disconnect notification
References: <1369405896-30246-1-git-send-email-kishon@ti.com>
 <1369405896-30246-4-git-send-email-kishon@ti.com>
In-reply-to: <1369405896-30246-4-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsWyRsSkUHfWk+WBBv8/81scvF9vMfXhEzaL
	A7MfslqcOric1aJ/i4vFgT87GC2aF69ns7jwtIfNYum+1SwW3650MFksbFvCYnF51xw2i9lL
	+lksFi1rZba43biCzeLwigNMFuteTmexON3N6iDkseDzFXaPnbPusntsWtXJ5vFq9UxWjzvX
	9rB5zDsZ6LF/7hp2j/MzFjJ69Da/Y/Po27KK0WPqlL+MHsdvbGfy+LxJLoA3issmJTUnsyy1
	SN8ugStj3q/jLAW/xCsWPVnK2MC4WqSLkZNDQsBE4tu0h+wQtpjEhXvr2boYuTiEBJYySiyc
	soURpujEjg4WiMQiRok5y48wQzgvGCX+9Z9gBqniFdCSuPR5MxOIzSKgKvHxJUgHJwcbUHz/
	ixtsILaoQJjEyulXWCDqBSV+TL4HZosA1Zze+QNsDrPAamaJps1hXYwcHMICCRJTz2eDmEIC
	hRIbzvKBVHAK2ElsPPiQDaJaR2J/6zQoW15i85q3YKdJCFzgkFh05RAjxDkCEt8mH2IBmSMh
	ICux6QAzxF+SEgdX3GCZwCg2C8lBs5CMnYVk7AJG5lWMoqkFyQXFSelFhnrFibnFpXnpesn5
	uZsYgani9L9nvTsYbx+wPsSYDLRyIrOUaHI+MNXklcQbGpsZWZiamBobmVuakSasJM6r1mId
	KCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRhX+75PbIrJV+3eGnVFV9I2tLIqY4sCyRSJUQ
	sd3v7LHVb1/YrWsfnRcf9/Nr4HkkqTLl7e+kKZ/L61eaz4hqbF6+N+OyUumfFyJ2PmekWtX8
	ORcEtp8MzTNZO8Pr/vFvJ82fme84s7f8jUhsx4STLf2r7Mp/Mny7dqFvw7qA5y8qdt7P0dJS
	YinOSDTUYi4qTgQALoNRuSsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t9jAd1ZT5YHGmzrZLM4eL/eYurDJ2wW
	B2Y/ZLU4dXA5q0X/FheLA392MFo0L17PZnHhaQ+bxdJ9q1ksvl3pYLJY2LaExeLyrjlsFrOX
	9LNYLFrWymxxu3EFm8XhFQeYLNa9nM5icbqb1UHIY8HnK+weO2fdZffYtKqTzePV6pmsHneu
	7WHzmHcy0GP/3DXsHudnLGT06G1+x+bRt2UVo8fUKX8ZPY7f2M7k8XmTXABvVAOjTUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Qi0oKZYk5pUChgMTi
	YiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjHm/jrMU/BKvWPRkKWMD42qRLkZODgkBE4kT
	OzpYIGwxiQv31rN1MXJxCAksYpSYs/wIM4TzglHiX/8JZpAqXgEtiUufNzOB2CwCqhIfX0J0
	swHF97+4wQZiiwqESaycfoUFol5Q4sfke2C2CFDN6Z0/wOYwC6xmlmjaHNbFyMEhLJAgMfV8
	NogpJFAoseEsH0gFp4CdxMaDD9kgqnUk9rdOg7LlJTavecs8gVFgFpIFs5CUzUJStoCReRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCJ6Jr2DcVWDxSFGAQ5GJR7egynLA4VYE8uKK3MP
	MUpwMCuJ8HaeAwrxpiRWVqUW5ccXleakFh9iTAb6fyKzlGhyPjBJ5pXEGxqbmBlZGpkbWhgZ
	m5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD47y37sctue7dEDWQZy14t7u73NTmSs2L
	OXoetZ5fNH8E7shINYgsu+T8+Pq2x7uEsxb/iFTc9mpzvE39roWmEgfO9e/u16tXetQXcu69
	f3+AdsVs93UTTnZ8PLfQ68rn3O7/WmJ2zDmlq+fy3T9wvGuTnqKthfj5qjMqlwO/fQ7genyR
	771lrBJLcUaioRZzUXEiAHPgHnaIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/24/2013 11:31 PM, Kishon Vijay Abraham I wrote:
> Modified dwc3-omap to receive connect and disconnect notification using
> extcon framework. Also did the necessary cleanups required after
> adapting to extcon framework.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/dwc3-omap.c  | 80 +++++++++++++++++++++++++++++++++----------
>  include/linux/usb/dwc3-omap.h | 30 ----------------
>  2 files changed, 62 insertions(+), 48 deletions(-)
>  delete mode 100644 include/linux/usb/dwc3-omap.h

Hi Kishon,

Thi patch is suspended until fix following build error.
(If kernel builds extcon fwr as module, dwc3-omap.c happen error message)

---
tree:   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon extcon-next
head:   30f5d6ea2561c2a54e40b1e8e8f9bb30e064e01b
commit: 30f5d6ea2561c2a54e40b1e8e8f9bb30e064e01b [3/3] usb: dwc3: use extcon fwrk to receive connect/disconnect notification
config: i386-randconfig-x14-0530 (attached as .config)

All error/warnings:

   drivers/built-in.o: In function `dwc3_omap_remove':
   dwc3-omap.c:(.text+0x8c0fa): undefined reference to `extcon_unregister_interest'
   dwc3-omap.c:(.text+0x8c102): undefined reference to `extcon_unregister_interest'
   drivers/built-in.o: In function `dwc3_omap_probe':
   dwc3-omap.c:(.text+0x8c5e6): undefined reference to `extcon_get_extcon_dev'
   dwc3-omap.c:(.text+0x8c6a4): undefined reference to `extcon_register_interest'
   dwc3-omap.c:(.text+0x8c6c9): undefined reference to `extcon_register_interest'
   dwc3-omap.c:(.text+0x8c831): undefined reference to `extcon_get_cable_state'
   dwc3-omap.c:(.text+0x8c851): undefined reference to `extcon_get_cable_state'
---

Also, I missed a issue of this patch. If h/w target use other USB device
instead of "palmas-usb", dwc-omap.c driver won't be operating.
So, I propose two method about this issue.
First, we can get extcon device name through platform data or dt.
Two, When use extcon_register_interest() to register notifier block,
NULL pointer pass to extcon_register_interest() instead of specific extcon
device name(palmas-usb). If extcon_register_interest() check NULL
pointer of extcon device name parameter, extcon fwr will find previous
registered extcon device and then register notifier block of consumer
device driver(dwc3-omap.c) to previous registered extcon device.

> +	edev = extcon_get_extcon_dev("palmas-usb");
> +	if (!edev) {
> +		dev_dbg(dev, "couldn't get extcon device\n");
> +		return -EPROBE_DEFER;
> +	}
> +
>  	spin_lock_init(&omap->lock);
>  
>  	omap->dev	= dev;
>  	omap->irq	= irq;
>  	omap->base	= base;
> +	omap->vbus_nb.notifier_call = dwc3_omap_vbus_notifier;
> +	extcon_register_interest(&omap->extcon_vbus_dev, "palmas-usb", "USB",
> +		&omap->vbus_nb);
> +	omap->id_nb.notifier_call = dwc3_omap_id_notifier;
> +	extcon_register_interest(&omap->extcon_id_dev, "palmas-usb", "USB-HOST",
> +		&omap->id_nb);
>  	dev->dma_mask	= &dwc3_omap_dma_mask;
>  
> +

Thanks,
Chanwoo Choi

