Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaEIKNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:13:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8849 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbaEIKNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:13:42 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-28-536caa51d12d
Message-id: <536CAA4F.8050404@samsung.com>
Date: Fri, 09 May 2014 12:13:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        kishon <kishon@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH v7 1/2] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1398665874-31238-1-git-send-email-gautam.vivek@samsung.com>
 <5368F136.6070804@samsung.com>
 <CAFp+6iHN-W-k6ow5YykK_QWgBJ+GgzXwPX6suWtizxwJWOiGtg@mail.gmail.com>
 <CAFp+6iF=Z_dkd+YJm2-ODmvgZ6PCt+bUx+vSVm_5RtobVN0WfA@mail.gmail.com>
In-reply-to: <CAFp+6iF=Z_dkd+YJm2-ODmvgZ6PCt+bUx+vSVm_5RtobVN0WfA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xa7qBq3KCDR5v4LA4eL/eYv6Rc6wW
	bVcOsls0L17PZvHj9QU2i94FV9ksLjztYbPY9Pgaq8XCtiUsFpd3zWGzmHF+H5PFomWtzBbr
	Z7xmceD12D93DbvH5iX1Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsEroxFS5ezFfRL
	VUxd2MzWwLhLpIuRk0NCwERi+ZQ2dghbTOLCvfVsXYxcHEICSxkl7s9dwQ7hfGKU2H58KitI
	Fa+AlkT3iQNMIDaLgKrEpxcr2UBsNgFDid6jfYxdjBwcogIREo8vCEGUC0r8mHyPBcQWEdCW
	2D53EivITGaB3SwSV///BZspLOAsMWHHSRaIZd8ZJZ6sXQe2gFMgWOLVlc1gC5gF1CUmzVvE
	DGHLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkAj5
	uoNx6TGrQ4wCHIxKPLwLZDKChVgTy4orcw8xSnAwK4nwPpueEyzEm5JYWZValB9fVJqTWnyI
	kYmDU6qBsfBkofL5i6Kqb/kubPp9173tyd/6nUneZ0TMvfuDtgZkRTn/9Vn8YvKV65FMhscU
	NKbtfXX98kHLg7LbDxx+1n9V9SdTleHd+D9hTr6ln54w+XrU/1h+uM3uu2j17A9q1QfVldwY
	D+VFBsXd+PR38Td5l0tG/Ay33DvuRe+OPNzmIx7R8zveTImlOCPRUIu5qDgRAHsBpzxuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 08/05/14 11:03, Vivek Gautam wrote:
>>>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>> >>> index b422e38..51efe4c 100644
>>>> >>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>> >>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>> >>> @@ -114,3 +114,43 @@ Example:
>>>> >>>               compatible = "samsung,exynos-sataphy-i2c";
>>>> >>>               reg = <0x38>;
>>>> >>>       };
>>>> >>> +
>>>> >>> +Samsung Exynos5 SoC series USB DRD PHY controller
>>>> >>> +--------------------------------------------------
>>>> >>> +
>>>> >>> +Required properties:
>>>> >>> +- compatible : Should be set to one of the following supported values:
>>>> >>> +     - "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
>>>> >>> +     - "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
>>>> >>> +- reg : Register offset and length of USB DRD PHY register set;
>>>> >>> +- clocks: Clock IDs array as required by the controller
>>>> >>> +- clock-names: names of clocks correseponding to IDs in the clock property;
>>>> >>> +            Required clocks:
>>>> >>> +     - phy: main PHY clock (same as USB DRD controller i.e. DWC3 IP clock),
>>>> >>> +            used for register access.
>>>> >>> +     - ref: PHY's reference clock (usually crystal clock), used for
>>>> >>> +            PHY operations, associated by phy name. It is used to
>>>> >>> +            determine bit values for clock settings register.
>>>> >>> +            For Exynos5420 this is given as 'sclk_usbphy30' in CMU.
>>>> >>> +- samsung,pmu-syscon: phandle for PMU system controller interface, used to
>>>> >>> +                   control pmu registers for power isolation.
>>>> >>> +- samsung,pmu-offset: phy power control register offset to pmu-system-controller
>>>> >>> +                   base.
>>> >>
>>> >> It doesn't seem right to have register offset encoded in the device tree
>>> >> like this. I think it'd be more appropriate to associate such an offset
>>> >> with the compatible string's value in the driver.
>> >
>> > Ok, it makes more sense.
>> > Just out of curiosity, what difference would this make ?
>
> Moreover, in case of Exynos5420 (and may be in future SoCs), where we
> have 2 USB DRD PHY controllers,
> we will need to have a way around to deal with two separate offsets in
> the driver for one compatible string.

It could be handled by creating a list of offsets per compatible string and
then adding some way to identify the PHY device instance. So I believe that's
not a big issue. Now you'd be encoding a list of registers offsets in the
device tree, without encoding bit layout of each register. It's unlikely that
each instance would have different bits layout, but describing individual 
registers in DT I thought is something that we're not supposed to do.
 
> Getting the offsets from DT seems a cleaner way to handle this case of
> multi controllers.

I think it's easier from the driver POV, but isn't it violating the device
tree rules ?
Anyway. I'm just pointing this minor issue in the binding as it appears
to me. The final word of course belongs to a DT binding maintainer.

Regards,
-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
