Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3JIVEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:04:55 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58040 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3JIVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <20131009210219.31110.62076.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131009210219.31110.62076.stgit@bhelgaas-glaptop.roam.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Oct 2013 15:04:32 -0600
Message-ID: <CAErSpo4RYGakLpJuhHyGTAMXvaZc63sjLiMrMneG9NjohanVZA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add arch/x86/pci to PCI file patterns
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 3:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> I handle many arch/x86/pci changes, so help those patches get to the
> PCI patchwork.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

I'll merge this via the PCI tree unless anybody objects.

> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e61c2e8..d1ab647 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6338,6 +6338,7 @@ S:        Supported
>  F:     Documentation/PCI/
>  F:     drivers/pci/
>  F:     include/linux/pci*
> +F:     arch/x86/pci/*
>
>  PCI DRIVER FOR NVIDIA TEGRA
>  M:     Thierry Reding <thierry.reding@gmail.com>
>
