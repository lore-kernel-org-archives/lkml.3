Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3GHUFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:05:43 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36085 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3GHUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:05:24 -0400
MIME-Version: 1.0
In-Reply-To: <00a301ce7b9b$f1c9bac0$d55d3040$%choi@samsung.com>
References: <00a301ce7b9b$f1c9bac0$d55d3040$%choi@samsung.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 8 Jul 2013 14:05:03 -0600
Message-ID: <CAErSpo41YnZ5cN4WXF12S-_pAkFmBS9uYAN6S61n6m8q5xRLwg@mail.gmail.com>
Subject: Re: [PATCH] PCI: fix typo in iov.c
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Sun, Jul 7, 2013 at 11:28 PM, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> Devic3 should be device.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

Patch was corrupted and not sent to linux-pci, but I applied it to my
pci/misc branch by hand.  Thanks!

Bjorn

> ---
>  drivers/pci/iov.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index de8ffac..de4034e 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -786,7 +786,7 @@ int pci_sriov_set_totalvfs(struct pci_dev *dev, u16
> numvfs)
>  EXPORT_SYMBOL_GPL(pci_sriov_set_totalvfs);
>
>  /**
> - * pci_sriov_get_totalvfs -- get total VFs supported on this devic3
> + * pci_sriov_get_totalvfs -- get total VFs supported on this device
>   * @dev: the PCI PF device
>   *
>   * For a PCIe device with SRIOV support, return the PCIe
> --
> 1.7.9.5
>
