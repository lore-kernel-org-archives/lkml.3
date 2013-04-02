Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab3DBWsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:48:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:55445 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab3DBWsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:48:11 -0400
Message-ID: <515B51F7.6070901@infradead.org>
Date: Tue, 02 Apr 2013 14:47:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com> <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/13 15:15, Jacob Pan wrote:
> diff --git a/drivers/platform/x86/intel_rapl.c b/drivers/platform/x86/intel_rapl.c
> new file mode 100644
> index 0000000..56ee928
> --- /dev/null
> +++ b/drivers/platform/x86/intel_rapl.c
> @@ -0,0 +1,1323 @@
> +/*
> + *  intel_rapl.c - Intel Running Average Power Limit Driver for MSR based
> + *                 RAPL interface
> + *
> + *  Copyright (c) 2013, Intel Corporation.
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +#include <linux/sysfs.h>
> +

> +#include "../../../fs/sysfs/sysfs.h"


What does this driver need from ^^^^^^ that file, which says:

 * fs/sysfs/sysfs.h - sysfs internal header file

and should that be moved to include/linux/sysfs.h ?


-- 
~Randy
