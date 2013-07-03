Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab3GCQBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:01:05 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43579 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3GCQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:01:02 -0400
MIME-Version: 1.0
In-Reply-To: <1372864578-6925-2-git-send-email-haicheng.li@linux.intel.com>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com> <1372864578-6925-2-git-send-email-haicheng.li@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 3 Jul 2013 10:00:41 -0600
Message-ID: <CAErSpo72XRbZYcepdHyhmY4oAqU1qLtCCXsEsyiCTvNCwvNktg@mail.gmail.com>
Subject: Re: [PATCH 2/3] doc: add the description for pci=hide kernel parameter.
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haicheng Li <haicheng.lee@gmail.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 9:16 AM, Haicheng Li <haicheng.li@linux.intel.com> wrote:
> Cc: Rob Landley <rob@landley.net>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> ---
>  Documentation/kernel-parameters.txt |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 2fe6e76..4da0834 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2359,6 +2359,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                 pcie_scan_all   Scan all possible PCIe devices.  Otherwise we
>                                 only look for one device below a PCIe downstream
>                                 port.
> +               hide=           Format: [<domain>:]<bus>:<slot>.<func>[; ...]
> +                               Specifies devices to hide from pci subsystem.
>
>         pcie_aspm=      [PCIE] Forcibly enable or disable PCIe Active State Power
>                         Management.

The documentation update should be in the same patch as the
functionality it adds.
