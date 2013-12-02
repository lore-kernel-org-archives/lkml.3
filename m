Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3LBUvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:51:08 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:60387 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3LBUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:50:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131202191254.396768627@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
	<20131202191254.396768627@linuxfoundation.org>
Date: Mon, 2 Dec 2013 15:50:57 -0500
X-Google-Sender-Auth: vv01Rymf5h97ksICw-ofUDBUuoY
Message-ID: <CA+5PVA4Hzon9Kcc0aDeGbbwUuvzx08n62UTYL11LsaY8FUUBRA@mail.gmail.com>
Subject: Re: [PATCH 3.12 056/212] ahci: add support for IBM Akebono platform device
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alistair Popple <alistair@popple.id.au>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 2:14 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.12-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Alistair Popple <alistair@popple.id.au>
>
> commit 2435dcb98cfe13c246aa27df393e22bc24bbcd20 upstream.
>
> The new IBM Akebono board has a PPC476GTR SoC with an AHCI compliant
> SATA controller. This patch adds a compatible property for the new SoC
> to the AHCI platform driver.
>
> Signed-off-by: Alistair Popple <alistair@popple.id.au>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This one is a little funny.  There's really nothing wrong with the
patch itself, nor adding it to 3.12.y, but it seems pretty pointless.
The support for the Akebono board hasn't even landed in 3.13-rcX yet,
and I really doubt it's going to show up in 3.12.y.  Seems kind of
superfluous.

josh

>
> ---
>  drivers/ata/ahci_platform.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -328,6 +328,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ah
>  static const struct of_device_id ahci_of_match[] = {
>         { .compatible = "snps,spear-ahci", },
>         { .compatible = "snps,exynos5440-ahci", },
> +       { .compatible = "ibm,476gtr-ahci", },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, ahci_of_match);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
