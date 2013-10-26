Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3JZBkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 21:40:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32555 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3JZBkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 21:40:06 -0400
Date: Sat, 26 Oct 2013 10:40:02 +0900
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 3/5] phy: Add support for S5PV210 to the Exynos USB PHY
 driver
In-reply-to: <526A933C.4020904@ti.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Kamil Debski'" <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Yulgon Kim'" <yulgon.kim@samsung.com>,
        "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Message-id: <003701ced1ec$4a511d40$def357c0$%han@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7bit
Thread-index: Ac7RmfFeGz2y+sBPSUWNTvYfhogQpQAUMqNg
DLP-Filter: Pass
X-AuditID: cbfee690-b7f3d6d000001c4a-d6-526b1d73c187
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+ZkW6xbHaQwfMbBhZLdt9gtZh/5Byr
	RduVg+wWlxdeYrX48foCm8WFpz1sFmeb3rBbTNv5n9Xi8q45bBYzzu9jsli0rJXZYu2Ru+wW
	Z/tvs1mc39LJZHH4TTurxfoZr1ksOs4eZHcQ9Ng56y67R9+WVYwex29sZ/L4vEkugCWKyyYl
	NSezLLVI3y6BK2P7qZMsBTt5K569vcXSwPiUq4uRg0NCwERi2jTBLkZOIFNM4sK99WxdjFwc
	QgLLGCVaW7rYIRImErvWXWaGSCxilDg08xOU84tRYtLt92BVbAJqEl++HAazRQRCJS5fbGcH
	KWIWuMYisaWrmQmiYzajxP5PvSwgVZxAHVsmzGYCsYUFQiS6Jy5nBrFZBFQlDv58yQJyH6+A
	rcSG+RUgYV4BQYkfk++BtTILaEms33mcCcKWl9i85i0zxDvqEo/+6kLcYCTxcNFfdogSEYl9
	L94xgpwgIbCFQ+L13LlQqwQkvk0+xALRKyux6QAzxMeSEgdX3GCZwCgxC8nmWUg2z0KyeRaS
	FQsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525ihCSGCTsY7x2wPsSYDLR+IrOUaHI+MLHk
	lcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjfH/X
	d2tm2nT9DNTx/t1h6tann6+Zvefn70gJJh5dxzVcJheOXLMxcksPsHrvdEL/2HvTiIN8DpM2
	pGQb5Ii8OXo8bMry46dib9tymV34/HiZ9s8zX3dW3mw/N2uC/TqZULPkcIt77yZzB7C0pDfW
	OyppmKj+Vy6RWn3WTfPpB2/2RRE+sWJKLMUZiYZazEXFiQC2aVkGIgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t9jAd1i2ewggwMPtSyW7L7BajH/yDlW
	i7YrB9ktLi+8xGrx4/UFNosLT3vYLM42vWG3mLbzP6vF5V1z2CxmnN/HZLFoWSuzxdojd9kt
	zvbfZrM4v6WTyeLwm3ZWi/UzXrNYdJw9yO4g6LFz1l12j74tqxg9jt/YzuTxeZNcAEtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDRSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM7adOshTs5K149vYWSwPjU64uRk4O
	CQETiV3rLjND2GISF+6tZ+ti5OIQEljEKHFo5idmCOcXo8Sk2+/ZQarYBNQkvnw5DGaLCIRK
	XL7Yzg5SxCxwjUViS1czE0THbEaJ/Z96WUCqOIE6tkyYzQRiCwuESHRPXA62j0VAVeLgz5dA
	NRwcvAK2EhvmV4CEeQUEJX5MvgfWyiygJbF+53EmCFteYvOat8wg5RIC6hKP/upC3GAk8XDR
	X3aIEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjBieeZ1A7GlQ0WhxgFOBiVeHgL2rOChFgTy4orcw8xSnAwK4nwrv4BFOJNSaysSi3Kjy8q
	zUktPsSYDPTnRGYp0eR8YFLMK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFq
	EcwWJg5OqQbGmvUtm86XyVTkL1qVZNys+9pysdb2MHud5CdT2bvnMvqUbfg1h919On/rE5md
	Mb55Tbni05bqX7x0Oc/7clwCe3HEh28qKdxH377oPbK7xqHB9c5Op/evGpiVS00f1x6raPup
	n9gV5eoRbVCXF9zGq2IjFDNPOi3rQeedvxHCXx69Yyjrj1BiKc5INNRiLipOBACg1iyugAMA	AA==
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
 <1382710529-12082-4-git-send-email-k.debski@samsung.com>
 <526A933C.4020904@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 26, 2013 12:50 AM, Kishon Vijay Abraham I wrote:
> On Friday 25 October 2013 07:45 PM, Kamil Debski wrote:
> > From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> >
> > Add support for the Samsung's S5PV210 SoC to the Exynos USB PHY driver.
> >
> > Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> > [k.debski@samsung.com: whitespace cleanup and commit description]
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> >  drivers/phy/Kconfig           |    7 ++
> >  drivers/phy/phy-exynos-usb.c  |   10 ++
> >  drivers/phy/phy-exynos-usb.h  |    1 +
> >  drivers/phy/phy-s5pv210-usb.c |  236 +++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 254 insertions(+)
> >  create mode 100644 drivers/phy/phy-s5pv210-usb.c

[.....]

> > diff --git a/drivers/phy/phy-s5pv210-usb.c b/drivers/phy/phy-s5pv210-usb.c
> > new file mode 100644
> > index 0000000..575275d
> > --- /dev/null
> > +++ b/drivers/phy/phy-s5pv210-usb.c
> 
> how different is this IP different from the previous ones? Does it deserve a
> separate driver or the previous drivers can be re-used?

[.....]

> > +const struct uphy_config s5pv210_uphy_config = {
> > +	.cpu		= TYPE_S5PV210,
> > +	.num_phys	= S5PV210_NUM_PHYS,
> > +	.phys		= s5pv210_phys,
> > +};
> 
> IMO this looks similar to the other drivers. Please re-use the drivers wherever
> possible.
> 

+cc Praveen Paneri(Author of Samsung PHY driver), Yulgon Kim, Anton Tikhomirov

I agree with Kishon's opinion.

Actually, all Exynos USB PHY controllers are not different IPs.
However, the differences between Exynos USB PHY controllers are
not little.

Best regards,
Jingoo Han

