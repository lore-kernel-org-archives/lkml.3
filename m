Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaJJITW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:19:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:42574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaJJITR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:19:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,690,1406617200"; 
   d="scan'208";a="612344255"
Message-ID: <1412929154.3713.74.camel@rzhang1-toshiba>
Subject: Re: linux-next: build failure after merge of the thermal tree
From: Zhang Rui <rui.zhang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 10 Oct 2014 16:19:14 +0800
In-Reply-To: <20141010121435.1a614c2b@canb.auug.org.au>
References: <20141010121435.1a614c2b@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 12:14 +1100, Stephen Rothwell wrote:
> Hi Zhang,
> 
> After merging the thermal tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from /scratch/sfr/next/init/main.c:27:0:
> /scratch/sfr/next/include/linux/acpi.h: In function 'acpi_create_platform_device':
> /scratch/sfr/next/include/linux/acpi.h:528:12: error: parameter name omitted
>      struct acpi_device *)
>             ^
> In file included from /scratch/sfr/next/drivers/i2c/i2c-core.c:54:0:
> /scratch/sfr/next/include/linux/acpi.h: In function 'acpi_create_platform_device':
> /scratch/sfr/next/include/linux/acpi.h:528:12: error: parameter name omitted
>      struct acpi_device *)
>             ^
> 
> And so on ...
> 
> Caused by commit 55fe2ff57c7e ("ACPI: make
> acpi_create_platform_device() an external API").  This build does not
> have CONFIG_ACPI set.  This has come along a bit late. :-(
> 
> I have used the thermal tree from next-20141009 for today.

I've fixed the problem in my tree. Please re-pull.

thanks,
rui

