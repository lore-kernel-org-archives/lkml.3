Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3L3NnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:43:11 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16561 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab3L3NnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:43:08 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-02-52c17868774d
From: Kamil Debski <k.debski@samsung.com>
To: "'Vivek Gautam'" <gautamvivek1987@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'kishon'" <kishon@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>, yulgon.kim@samsung.com,
        "'Praveen Paneri'" <p.paneri@samsung.com>, av.tikhomirov@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Kumar Gala'" <galak@codeaurora.org>, matt.porter@linaro.org,
        tjakobi@math.uni-bielefeld.de,
        "'Alan Stern'" <stern@rowland.harvard.edu>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
 <1387545857-9472-5-git-send-email-k.debski@samsung.com>
 <CAFp+6iHd12a8Aqg2BjixzokohPEuYsK9gPu+fkQ1u3-5uw2L=g@mail.gmail.com>
In-reply-to: <CAFp+6iHd12a8Aqg2BjixzokohPEuYsK9gPu+fkQ1u3-5uw2L=g@mail.gmail.com>
Subject: RE: [PATCH v5 4/9] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
Date: Mon, 30 Dec 2013 14:43:02 +0100
Message-id: <028601cf0565$10b496a0$321dc3e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8CIytDi0JPCdPPRk2q7lh321GEbgDKfUYw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t/xy7oZFQeDDM6cMrJYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i7fct7BaXF15itbjwtIfN4mzTGyB31xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJvy+wWayf8ZrFom31B1aLjrMH2R1EPC739TJ57Jx1l93j
	zrU9bB7/jrF7zL77g9Gjb8sqRo/jN7YzeXzeJBfAEcVlk5Kak1mWWqRvl8CVMf3SWqaC1/4V
	j79OY2xgnGLWxcjJISFgItG+fyYbhC0mceHeeiCbi0NIYCmjxKwFkxkhnAYmie/HXzN3MXJw
	sAloSqy65wHSICKgJzGteR5YDbPAGVaJO9vOQDUcYZRYMekNK0gVp0CwxIHZS1lAbGGBFIlN
	e1+AxVkEVCX+XlgOZvMKOEgsPrKdCcIWlPgx+R5YPbOAlsT6nceZIGx5ic1r3oIdISGgLvHo
	ry7EEUZAH7SyQpSISNxteM46gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqaWJhcUJ6XnGukVJ+YW
	l+al6yXn525ihETz1x2MS49ZHWIU4GBU4uENuHEgSIg1say4MvcQowQHs5II75nIg0FCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGKfx9yVMmL/eiflom/6ffIMr9V0fD6wSXTwnUPTo4n1pZ8T+
	Bwjvti36z362xaSH778xz5YPF1i+iKb33I6z5C6ukNm27lTmiYmtfo8vzD/7UqSlctV6p68O
	TKa5U6u+33jgcULJbtLphutGGmG39k39VGhsc+jptmk/Ejqf67dJ1b67Im9T8FmJpTgj0VCL
	uag4EQAI0lAlxAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> From: Vivek Gautam [mailto:gautamvivek1987@gmail.com]
> Sent: Thursday, December 26, 2013 11:14 AM
> 
> Hi Kamil,
> 
> 
> On Fri, Dec 20, 2013 at 6:54 PM, Kamil Debski <k.debski@samsung.com>
> wrote:
> > Change the phy provider used from the old one using the USB phy
> > framework to a new one using the Generic phy framework.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Commit title:
> s/ehci-s5p/ehci-exynos

Thank you for spotting this.

> 
> > ---
> >  Documentation/devicetree/bindings/usb/usb-ehci.txt |   35 +++++++
> >  drivers/usb/host/ehci-exynos.c                     |   97
> +++++++++++++-------
> >  2 files changed, 98 insertions(+), 34 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/usb/usb-ehci.txt
> > b/Documentation/devicetree/bindings/usb/usb-ehci.txt
> > index fa18612..413f7cd 100644
> > --- a/Documentation/devicetree/bindings/usb/usb-ehci.txt
> > +++ b/Documentation/devicetree/bindings/usb/usb-ehci.txt
> > @@ -14,6 +14,10 @@ If controller implementation operates with big
> > endian descriptors,  If both big endian registers and descriptors are
> > used by the controller  implementation, "big-endian" property can be
> > specified instead of having  both "big-endian-regs" and "big-endian-
> desc".
> > +  - port: if in the SoC there are EHCI phys, they should be listed
> here.
> > +One phy per port. Each port should have its reg entry with a
> > +consecutive number. Also it should contain phys and phy-names
> entries
> > +specifying the phy used by the port.
> >
> >  Example (Sequoia 440EPx):
> >      ehci@e0000300 {
> > @@ -23,3 +27,34 @@ Example (Sequoia 440EPx):
> >            reg = <0 e0000300 90 0 e0000390 70>;
> >            big-endian;
> >     };
> > +
> > +Example (Exynos 4212):
> > +    ehci@12580000 {
> > +        compatible = "samsung,exynos4210-ehci";
> > +        reg = <0x12580000 0x20000>;
> > +        interrupts = <0 70 0>;
> > +        clocks = <&clock 304>, <&clock 305>;
> > +        clock-names = "usbhost", "otg";
> > +        status = "disabled";
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +        port@0 {
> > +            reg = <0>;
> > +            phys = <&usb2phy 1>;
> > +            phy-names = "host";
> > +            status = "disabled";
> > +        };
> > +        port@1 {
> > +            reg = <1>;
> > +            phys = <&usb2phy 2>;
> > +            phy-names = "hsic0";
> > +            status = "disabled";
> > +        };
> > +        port@2 {
> > +            reg = <2>;
> > +            phys = <&usb2phy 3>;
> > +            phy-names = "hsic1";
> > +            status = "disabled";
> > +        };
> > +    };
> 
> Should we place above documentation in
> "Documentation/devicetree/bindings/usb/exynos-usb.txt" ?
> or is it something that i am missing. 

Indeed, this should go to exynos-usb.txt instead of usb-ehci.txt.
Thanks!

> > +
> > diff --git a/drivers/usb/host/ehci-exynos.c
> > b/drivers/usb/host/ehci-exynos.c index d1d8c47..7c35501 100644
> > --- a/drivers/usb/host/ehci-exynos.c
> > +++ b/drivers/usb/host/ehci-exynos.c
> > @@ -19,12 +19,12 @@
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/of_gpio.h>
> > +#include <linux/phy/phy.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/usb/phy.h>
> >  #include <linux/usb/samsung_usb_phy.h>  #include <linux/usb.h>
> > #include <linux/usb/hcd.h> -#include <linux/usb/otg.h>
> >
> >  #include "ehci.h"
> >
> > @@ -42,10 +42,10 @@
> >  static const char hcd_name[] = "ehci-exynos";  static struct
> > hc_driver __read_mostly exynos_ehci_hc_driver;
> >
> > +#define PHY_NUMBER 3
> >  struct exynos_ehci_hcd {
> >         struct clk *clk;
> > -       struct usb_phy *phy;
> > -       struct usb_otg *otg;
> > +       struct phy *phy[PHY_NUMBER];
> >  };
> >
> >  #define to_exynos_ehci(hcd) (struct exynos_ehci_hcd
> > *)(hcd_to_ehci(hcd)->priv) @@ -69,13 +69,43 @@ static void
> exynos_setup_vbus_gpio(struct platform_device *pdev)
> >                 dev_err(dev, "can't request ehci vbus gpio %d",
> gpio);
> > }
> >
> > +static int exynos_phys_on(struct phy *p[]) {
> > +       int i;
> > +       int ret = 0;
> > +
> > +       for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> > +               if (p[i])
> > +                       ret = phy_power_on(p[i]);
> > +       if (ret)
> > +               for (i--; i > 0; i--)
> > +                       if (p[i])
> > +                               phy_power_off(p[i]);
> 
> So we are turning off, say, port0 phy in case port1 phy power_on fails;
> can't we still leave a usb2.0 phy(a normal host phy) 'on' in case the
> HSIC phy fails ?

Currently all phys are can be either switched on or off. So if powering on
one phy fails (and exynos_phy_on returns an error code), I would expect
that no phy is switched on. I think that doing otherwise could leave
the phys in strange state - some phys are on, some are off and the power_on
call returned an error.

> > +
> > +       return ret;
> > +}
> > +
> > +static int exynos_phys_off(struct phy *p[]) {
> > +       int i;
> > +       int ret = 0;
> > +
> > +       for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> > +               if (p[i])
> > +                       ret = phy_power_off(p[i]);
> > +
> > +       return ret;
> > +}
> > +
> >  static int exynos_ehci_probe(struct platform_device *pdev)  {
> >         struct exynos_ehci_hcd *exynos_ehci;
> >         struct usb_hcd *hcd;
> >         struct ehci_hcd *ehci;
> >         struct resource *res;
> > -       struct usb_phy *phy;
> > +       struct phy *phy;
> > +       struct device_node *child;
> > +       int phy_number;
> >         int irq;
> >         int err;
> >
> > @@ -102,14 +132,26 @@ static int exynos_ehci_probe(struct
> platform_device *pdev)
> >                                         "samsung,exynos5440-ehci"))
> >                 goto skip_phy;
> >
> > -       phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> > -       if (IS_ERR(phy)) {
> > -               usb_put_hcd(hcd);
> > -               dev_warn(&pdev->dev, "no platform data or transceiver
> defined\n");
> > -               return -EPROBE_DEFER;
> > -       } else {
> > -               exynos_ehci->phy = phy;
> > -               exynos_ehci->otg = phy->otg;
> > +       for_each_available_child_of_node(pdev->dev.of_node, child) {
> > +               err = of_property_read_u32(child, "reg",
> &phy_number);
> > +               if (err) {
> > +                       dev_err(&pdev->dev, "Failed to parse device
> tree\n");
> > +                       of_node_put(child);
> > +                       return err;
> > +               }
> > +               if (phy_number >= PHY_NUMBER) {
> > +                       dev_err(&pdev->dev, "Failed to parse device
> tree - number out of range\n");
> > +                       of_node_put(child);
> > +                       return -EINVAL;
> > +               }
> > +               phy = devm_of_phy_get(&pdev->dev, child, 0);
> > +               of_node_put(child);
> > +               if (IS_ERR(phy)) {
> > +                       dev_err(&pdev->dev, "Failed to get phy number
> %d",
> > +
> phy_number);
> > +                       return PTR_ERR(phy);
> > +               }
> > +               exynos_ehci->phy[phy_number] = phy;
> >         }
> >
> >  skip_phy:
> > @@ -149,11 +191,11 @@ skip_phy:
> >                 goto fail_io;
> >         }
> >
> > -       if (exynos_ehci->otg)
> > -               exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd-
> >self);
> > -
> > -       if (exynos_ehci->phy)
> > -               usb_phy_init(exynos_ehci->phy);
> > +       err = exynos_phys_on(exynos_ehci->phy);
> > +       if (err) {
> > +               dev_err(&pdev->dev, "Failed to enabled phys\n");
> > +               goto fail_io;
> > +       }
> >
> >         ehci = hcd_to_ehci(hcd);
> >         ehci->caps = hcd->regs;
> > @@ -173,8 +215,7 @@ skip_phy:
> >         return 0;
> >
> >  fail_add_hcd:
> > -       if (exynos_ehci->phy)
> > -               usb_phy_shutdown(exynos_ehci->phy);
> > +       exynos_phys_off(exynos_ehci->phy);
> >  fail_io:
> >         clk_disable_unprepare(exynos_ehci->clk);
> >  fail_clk:
> > @@ -189,11 +230,7 @@ static int exynos_ehci_remove(struct
> > platform_device *pdev)
> >
> >         usb_remove_hcd(hcd);
> >
> > -       if (exynos_ehci->otg)
> > -               exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd-
> >self);
> > -
> > -       if (exynos_ehci->phy)
> > -               usb_phy_shutdown(exynos_ehci->phy);
> > +       exynos_phys_off(exynos_ehci->phy);
> >
> >         clk_disable_unprepare(exynos_ehci->clk);
> >
> > @@ -213,11 +250,7 @@ static int exynos_ehci_suspend(struct device
> > *dev)
> >
> >         rc = ehci_suspend(hcd, do_wakeup);
> >
> > -       if (exynos_ehci->otg)
> > -               exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd-
> >self);
> > -
> > -       if (exynos_ehci->phy)
> > -               usb_phy_shutdown(exynos_ehci->phy);
> > +       exynos_phys_off(exynos_ehci->phy);
> >
> >         clk_disable_unprepare(exynos_ehci->clk);
> >
> > @@ -231,11 +264,7 @@ static int exynos_ehci_resume(struct device
> *dev)
> >
> >         clk_prepare_enable(exynos_ehci->clk);
> >
> > -       if (exynos_ehci->otg)
> > -               exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd-
> >self);
> > -
> > -       if (exynos_ehci->phy)
> > -               usb_phy_init(exynos_ehci->phy);
> > +       exynos_phys_on(exynos_ehci->phy);
> >
> >         /* DMA burst Enable */
> >         writel(EHCI_INSNREG00_ENABLE_DMA_BURST,
> > EHCI_INSNREG00(hcd->regs));
> > --
> 
> Rest all looks good. :-)
> I tested this patch along with other patches in the series on smdk5250.

Thank you :)

> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> 

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


