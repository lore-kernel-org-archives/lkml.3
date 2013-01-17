Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3AQXZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:25:55 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:53998 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3AQXZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <1358391258-1771-57-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org> <1358391258-1771-57-git-send-email-keescook@chromium.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 17 Jan 2013 16:25:32 -0700
Message-ID: <CAErSpo7XmLcNjfh22JuQ71+hybZ-WCfn_XKzc4aiRde00AOdvg@mail.gmail.com>
Subject: Re: [PATCH 56/86] drivers/pci/pcie: remove depends on CONFIG_EXPERIMENTAL
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Wed, Jan 16, 2013 at 7:53 PM, Kees Cook <keescook@chromium.org> wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> CC: Matthew Garrett <mjg@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

I missed this the first time you posted it, so thanks for resending
it.  I applied it to my for-linus branch, headed for v3.8.

> ---
>  drivers/pci/pcie/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
> index 6c8bc58..fde4a32 100644
> --- a/drivers/pci/pcie/Kconfig
> +++ b/drivers/pci/pcie/Kconfig
> @@ -82,4 +82,4 @@ endchoice
>
>  config PCIE_PME
>         def_bool y
> -       depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL && ACPI
> +       depends on PCIEPORTBUS && PM_RUNTIME && ACPI
> --
> 1.7.9.5
>
