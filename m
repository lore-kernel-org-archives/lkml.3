Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaATOvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:51:14 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:60613 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaATOvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:51:10 -0500
MIME-Version: 1.0
In-Reply-To: <1390228888-5537-3-git-send-email-rogerq@ti.com>
References: <1390228888-5537-1-git-send-email-rogerq@ti.com>
	<1390228888-5537-3-git-send-email-rogerq@ti.com>
Date: Mon, 20 Jan 2014 08:51:09 -0600
Message-ID: <CAL_JsqL+nPAD2irDRr5tJLV=xOsGgPwmmMbSL7tG7Edq5d0xyw@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] ata: ahci_platform: Update DT compatible list
From: Rob Herring <robherring2@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Tejun Heo <tj@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, b.zolnierkie@samsung.com,
        hdegoede@redhat.com, Arnd Bergmann <arnd@arndb.de>,
        linux-ide@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 8:41 AM, Roger Quadros <rogerq@ti.com> wrote:
> The ahci_platform driver supports "snps,exynos5440-ahci", "ibm,476gtr-ahci"
> and "snps,dwc-ahci". Add this to the DT binding information.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  Documentation/devicetree/bindings/ata/ahci-platform.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> index 89de156..08ba647 100644
> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> @@ -4,7 +4,9 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
>  Each SATA controller should have its own node.
>
>  Required properties:
> -- compatible        : compatible list, contains "snps,spear-ahci"
> +- compatible        : compatible list, contains "snps,spear-ahci",
> +                     "snps,exynos5440-ahci", "ibm,476gtr-ahci",
> +                     or "snps,dwc-ahci"
>  - interrupts        : <interrupt mapping for SATA IRQ>
>  - reg               : <registers mapping>
>
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
