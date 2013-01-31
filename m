Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3AaRP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:15:29 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:42343 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab3AaRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:15:24 -0500
MIME-Version: 1.0
In-Reply-To: <1358944146-28884-1-git-send-email-wangyijing@huawei.com>
References: <1358944146-28884-1-git-send-email-wangyijing@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 31 Jan 2013 10:15:03 -0700
Message-ID: <CAErSpo4DrTBPxOr9va8TCknu-HgC2zKyOGRP7w02_-_W8s2KmQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Document PCI Hotplug resource reservation parameters
To: Yijing Wang <wangyijing@huawei.com>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 5:29 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> Document pci hotplug resource reservation parameters hpiosize
> and hpmemsize into Documentation/kernel-parameters.txt.
> The two parameters can override default hotplug io size(256 bytes)
> and default mem size(2M).
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  Documentation/kernel-parameters.txt |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 1fb269b..46eff3d 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2263,6 +2263,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                                 the default.
>                                 off: Turn ECRC off
>                                 on: Turn ECRC on.
> +               hpiosize=nn[KMG]        The fixed amount of bus space which is
> +                               reserved for hotplug bridge's IO window.
> +                               Default size is 256 bytes.
> +               hpmemsize=nn[KMG]       The fixed amount of bus space which is
> +                               reserved for hotplug bridge's memory window.
> +                               Default size is 2 megabytes.
>                 realloc=        Enable/disable reallocating PCI bridge resources
>                                 if allocations done by BIOS are too small to
>                                 accommodate resources required by all child
> --
> 1.7.1
>
>

Added to pci/misc for v3.9.  Thanks!
