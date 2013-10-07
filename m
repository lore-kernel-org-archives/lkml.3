Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3JGXWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:22:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28835 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3JGXWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:22:34 -0400
X-AuditID: cbfee68e-b7f756d000004512-df-52534238190d
From: Kukjin Kim <kgene@kernel.org>
To: "'Vinod Koul'" <vinod.koul@intel.com>,
        "=?ISO-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>
Cc: "'Dan Williams'" <djbw@fb.com>, linus.walleij@linaro.org,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Sylwester Nawrocki'" <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <201309182118.28391.heiko@sntech.de>
 <201309182119.54560.heiko@sntech.de> <20131007143351.GK2954@intel.com>
In-reply-to: <20131007143351.GK2954@intel.com>
Subject: RE: [PATCH v5 2/4] dmaengine: add driver for Samsung s3c24xx SoCs
Date: Tue, 08 Oct 2013 08:22:32 +0900
Message-id: <0f4401cec3b4$19648230$4c2d8690$@org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7DcbB82HbKwZQ2TVegZwHMGm+MjwAQk6hg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zI10Lp+Agg0sbzS029z9gs/j/6DWr
	xZQ/y5ksLu+aw2Yx4/w+Jot5n3cyWaza9YfR4mXffhYHDo+Jze/YPXbOusvusXjPSyaPO9f2
	sHlsvzaP2ePzJrkAtigum5TUnMyy1CJ9uwSujLtzGtkKpnFVvOiZydzA2MHRxcjJISFgInH2
	zBw2CFtM4sK99UA2F4eQwDJGiR+LrjHCFO14eBLMFhKYzihx7L0CRNFfRokd39+zdDFycLAJ
	KEs0NumD1AgLaEks3NLEAmKLCMRLtM9fyw5Szyxwl1HiS/8KqEGVEu/OdDOD2JwCehJLZ65g
	h2j2kpi77TxYnEVAVWLTzIVgg3gFDCVWNz5nhrAFJX5MvgcWZxbQkdjfOo0NwtaWePLuAivI
	PRIC6hKP/upC3GAkceXvEUaIEhGJfS/eMYLcIyHQySHRdGIdG8QuAYlvkw+xQPTKSmw6wAzx
	u6TEwRU3WCYwSs5CsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxgh
	kd63g/HmAetDjMlA6ycyS4km5wMTRV5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZ
	qakFqUXxRaU5qcWHGJk4OKUaGIP6XI9PfnEl0MPy1NdzzpFnXm+NOpouZb+nN3LBcpEsgV6+
	P5+TvhTFrFn24hGjgLmIjtn92bL3/swxe+l43W7B138iT78vibxy8+u8tpCV/5x/LE0PfpPY
	ePWs2eZc1X/q6qx1ySH8+2N/G3G12LCz+9248EhZfLa4n/aUjyaedixnftUk/1FiKc5INNRi
	LipOBAAGlh0ECgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jQV0Lp+Agg50HjSw29z9gs/j/6DWr
	xZQ/y5ksLu+aw2Yx4/w+Jot5n3cyWaza9YfR4mXffhYHDo+Jze/YPXbOusvusXjPSyaPO9f2
	sHlsvzaP2ePzJrkAtqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBl35zSy
	FUzjqnjRM5O5gbGDo4uRk0NCwERix8OTjBC2mMSFe+vZQGwhgemMEsfeK3QxcgHZfxkldnx/
	z9LFyMHBJqAs0dikD1IjLKAlsXBLEwuILSIQL9E+fy07SD2zwF1GiS/9KxghBlVKvDvTzQxi
	cwroSSyduYIdotlLYu6282BxFgFViU0zF4IN4hUwlFjd+JwZwhaU+DH5HlicWUBHYn/rNDYI
	W1viybsLrCD3SAioSzz6qwtxg5HElb9HGCFKRCT2vXjHOIFReBaSSbOQTJqFZNIsJC0LGFlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSnkWfSOxhXNVgcYhTgYFTi4RU4HBQkxJpYVlyZ
	e4hRgoNZSYRXwCg4SIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgSkuryTe0NjEzMjSyMzC
	yMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYC6Qvfyy+IHTg8+Y0WT7DS00NHpmT
	X4XuvdP0gLVgkk+lSIjvp8S2WvOmH4LZRo2bPSZFGJ5+ujtfNXr3s92vXl+T3bhbcwZr7L4X
	D3V397iL1iUrH3I+yzqzOcV4En/Wd547iXUT99+eOXt1TQVLspLZitxXgcvCV8/3Cr2U/TR5
	6cFn++1slFiKMxINtZiLihMBiiBSuGcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vinod Koul wrote:
> 
> On Wed, Sep 18, 2013 at 09:19:54PM +0200, Heiko Stübner wrote:
> > This adds a new driver to support the s3c24xx dma using the dmaengine
> > and makes the old one in mach-s3c24xx obsolete in the long run.
> >
> > Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> > with numerous virtual channels being mapped to a lot less physical ones.
> > The driver therefore borrows a lot from the amba-pl08x driver in this
> > regard. Functionality-wise the driver gains a memcpy ability in addition
> > to the slave_sg one.
> >
> > The driver supports both the method for requesting the peripheral used
> > by SoCs before the S3C2443 and the different method for S3C2443 and
> later.
> >
> > On earlier SoCs the hardware channels usable for specific peripherals is
> > constrainted while on later SoCs all channels can be used for any
> peripheral.
> >
> > Tested on a s3c2416-based board, memcpy using the dmatest module and
> > slave_sg partially using the spi-s3c64xx driver.
> >
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Vinod Koul <vinod.koul@intel.com>
> 
Vinod, thanks for your ack :-)

Applied this whole series.
Kukjin

