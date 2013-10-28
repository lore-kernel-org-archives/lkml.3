Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3J1Nwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:52:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11838 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3J1Nwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:52:43 -0400
Date: Mon, 28 Oct 2013 14:52:40 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH v2 1/5] phy: Add new Exynos USB PHY driver
In-reply-to: <1A9F8795-C8EC-443C-9396-49BBA589C8B7@codeaurora.org>
To: "'Kumar Gala'" <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org, kyungmin.park@samsung.com, kishon@ti.com,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com
Message-id: <025d01ced3e4$f8e51510$eaaf3f30$%debski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7bit
Thread-index: Ac7RyjrGqYw1Nu2+QRuKO0q2vLod7ACE2ISQ
X-AuditID: cbfec7f4-b7f0a6d000007b1b-ad-526e6c2ae63f
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4VV2tnLwggxUf2S3mHznHatH/ZiGr
	RduVg+wWF572sFmcbXrDbjFt539Wi8u75rBZzDi/j8li0bJWZou1R+6yW5ztv81mcfhNO6vF
	+hmvWRx4PS739TJ57Jx1l92jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mWWqRvl8CV8at9NmPB
	c4WKb48fMzUwfpDoYuTkkBAwkdjcsJEdwhaTuHBvPVsXIxeHkMBSRomeEy+YIJwGJomTBx8D
	ORwcbAKaEqvueYA0iAioS0zbcZEVpIZZ4DuTxJ0vR9khGrYzSixtWMQEUsUp4CRxbv0esBXC
	AnYSPz69YwSxWQRUJRbN/sAMYvMKOEhMevGCEcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfM
	IEdIAG1+9FcX4ggjiSNrP7JDlIhI3G14zjqBUWgWkkmzkEyahWTSLCQtCxhZVjGKppYmFxQn
	peca6hUn5haX5qXrJefnbmKExNqXHYyLj1kdYhTgYFTi4d2wNjdIiDWxrLgy9xCjBAezkgjv
	1Li8ICHelMTKqtSi/Pii0pzU4kOMTBycUg2MZVdznb9pbhM4eeuFR9nzQ1KsBTpyQc3TDz/M
	K9N6dSG4gufVfN/S7ynrbFR/9mbZ2USrJCyPT7zFx5zM+E1uqeq8ivviDXN8jILd9F9cvuf+
	2qNd475ki82PN11uJ0JKDVMuXknZY3VI5I2LQKJubumyOW/chVbPKj7bnPVxQuDbe5lO334o
	sRRnJBpqMRcVJwIA/MpxCJMCAAA=
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
 <1382710529-12082-2-git-send-email-k.debski@samsung.com>
 <1A9F8795-C8EC-443C-9396-49BBA589C8B7@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar Gala,

> From: Kumar Gala [mailto:galak@codeaurora.org]
> Sent: Friday, October 25, 2013 11:36 PM
> 
> On Oct 25, 2013, at 9:15 AM, Kamil Debski wrote:
> 
> > Add a new driver for the Exynos USB PHY. The new driver uses the
> > generic PHY framework. The driver includes support for the Exynos
> 4x10
> > and 4x12 SoC families.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > .../devicetree/bindings/phy/samsung-usbphy.txt     |   51 +++
> > drivers/phy/Kconfig                                |   21 ++
> > drivers/phy/Makefile                               |    3 +
> > drivers/phy/phy-exynos-usb.c                       |  245
> ++++++++++++++
> > drivers/phy/phy-exynos-usb.h                       |   94 ++++++
> > drivers/phy/phy-exynos4210-usb.c                   |  295
> +++++++++++++++++
> > drivers/phy/phy-exynos4212-usb.c                   |  343
> ++++++++++++++++++++
> > 7 files changed, 1052 insertions(+)
> > create mode 100644
> > Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> > create mode 100644 drivers/phy/phy-exynos-usb.c create mode 100644
> > drivers/phy/phy-exynos-usb.h create mode 100644
> > drivers/phy/phy-exynos4210-usb.c create mode 100644
> > drivers/phy/phy-exynos4212-usb.c
> >
> > diff --git a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> > b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> > new file mode 100644
> > index 0000000..f112b37
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> > @@ -0,0 +1,51 @@
> > +Samsung S5P/EXYNOS SoC series USB PHY
> > +-------------------------------------------------
> > +
> > +Required properties:
> > +- compatible : should be one of the listed compatibles:
> > +	- "samsung,exynos4210-usbphy"
> > +	- "samsung,exynos4212-usbphy"
> > +- reg : a list of registers used by phy driver
> > +	- first and obligatory is the location of phy modules registers
> > +	- second and also required is the location of isolation registers
> > +	  (isolation registers control the physical connection between
> the in
> > +	  SoC modules and outside of the SoC, this also can be called
> enable
> > +	  control in the documentation of the SoC)
> > +	- third is the location of the mode switch register, this only
> applies
> > +	  to SoCs that have such a feature; mode switching enables to
> have
> > +	  both host and device used the same SoC pins and is commonly
> used
> > +	  when OTG is supported
> > +- #phy-cells : from the generic phy bindings, must be 1;
> 
> Please add if clock & clock-names are required properties.

Ok, thanks for pointing this out.

> 
> > +
> > +The second cell in the PHY specifier identifies the PHY its meaning
> > +is SoC dependent. For the currently supported SoCs (Exynos 4210 and
> > +Exynos 4212) it is as follows:
> 
> Can we say instead of 'its meaning is SoC dependent...' something like
> 'its meaning is compatible dependent"?

Ok, this sounds better in deed.
 
> > +  0 - USB device,
> > +  1 - USB host,
> > +  2 - HSIC0,
> > +  3 - HSIC1,
> > +
> > +Example:
> > +
> > +For Exynos 4412 (compatible with Exynos 4212):
> > +
> > +exynos_usbphy: exynos-usbphy@125B0000 {
> > +	compatible = "samsung,exynos4212-usbphy";
> > +	reg = <0x125B0000 0x100 0x10020704 0x0c 0x1001021c 0x4>;
> > +	ranges;
> > +	#address-cells = <1>;
> > +	#size-cells = <1>;
> 
> Why do you have ranges, and #address-cells & #size-cells here?

As, I mentioned in my reply to Kishon. I worked on two branches
and I forgot to remove this in the one used to generate patches.

> 
> > +	clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
> > +							<&clock 2>;
> > +	clock-names = "phy", "device", "host", "hsic0", "hsic1";
> > +	status = "okay";
> > +	#phy-cells = <1>;
> > +};
> > +
> > +Then the PHY can be used in other nodes such as:
> > +
> > +ehci@12580000 {
> > +	status = "okay";
> > +	phys = <&exynos_usbphy 2>;
> > +	phy-names = "hsic0";
> > +};
> 

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

