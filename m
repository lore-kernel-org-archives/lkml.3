Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab3ANM56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:57:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40459 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab3ANM54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:57:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Toshi Kani <toshi.kani@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>
Subject: Re: [PATCH] ACPI: remove unused acpi_op_bind and acpi_op_unbind
Date: Mon, 14 Jan 2013 14:03:45 +0100
Message-ID: <6680981.KaANYo3b18@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358086602-32538-1-git-send-email-jiang.liu@huawei.com>
References: <2326457.ZgAhayTgyl@vostro.rjw.lan> <1358086602-32538-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 13, 2013 10:16:42 PM Jiang Liu wrote:
> 
> With commit f2a33cde55a03 "ACPI: Drop ACPI device .bind() and .unbind()
> callbacks", acpi_op_bind and acpi_op_unbind are not used any more. So
> remove them.

Applied to the linux-next branch of the linux-pm.git tree as v3.9 material.

Please CC ACPI patches to linux-acpi@vger.kernel.org in the future, though,
that makes it much easier to handle them for me.

Thanks,
Rafael


> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  include/acpi/acpi_bus.h |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 6e9a73e..ef539eb 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -91,8 +91,6 @@ struct acpi_device;
>  typedef int (*acpi_op_add) (struct acpi_device * device);
>  typedef int (*acpi_op_remove) (struct acpi_device * device, int type);
>  typedef int (*acpi_op_start) (struct acpi_device * device);
> -typedef int (*acpi_op_bind) (struct acpi_device * device);
> -typedef int (*acpi_op_unbind) (struct acpi_device * device);
>  typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
>  
>  struct acpi_device_ops {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
