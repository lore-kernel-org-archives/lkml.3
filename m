Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaA2Uye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:54:34 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37563 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaA2Uyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:54:32 -0500
MIME-Version: 1.0
In-Reply-To: <1390232575-4284-1-git-send-email-standby24x7@gmail.com>
References: <1390232575-4284-1-git-send-email-standby24x7@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 29 Jan 2014 13:54:11 -0700
Message-ID: <CAErSpo6B_o4Y_oASU3ZR+NVtk-XDw0CJS8RVeX6G9zgr8r3K_g@mail.gmail.com>
Subject: Re: [PATCH][trivial] pci: Fix make htmldocs failure caused by msi.c
To: Masanari Iida <standby24x7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alexander Gordeev <agordeev@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 8:42 AM, Masanari Iida <standby24x7@gmail.com> wrote:
> An empty line in msi.c caused "make htmldocs" failure.
> Warning(/home/iida/Repo/linux-next//drivers/pci/msi.c:962): bad line:
> Remove the empty line fixed the issue.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied to my pci/msi branch, thanks!

>
> ---
>  drivers/pci/msi.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 7a0fec6..a9d5176 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -959,7 +959,6 @@ EXPORT_SYMBOL(pci_disable_msi);
>  /**
>   * pci_msix_vec_count - return the number of device's MSI-X table entries
>   * @dev: pointer to the pci_dev data structure of MSI-X device function
> -
>   * This function returns the number of device's MSI-X table entries and
>   * therefore the number of MSI-X vectors device is capable of sending.
>   * It returns a negative errno if the device is not capable of sending MSI-X
> --
> 1.9.rc0
>
