Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab3K3B5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 20:57:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55818 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3K3B47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 20:56:59 -0500
Message-ID: <529945E9.303@infradead.org>
Date: Fri, 29 Nov 2013 17:56:57 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: linux-next: Tree for Nov 29 (i915/intel_opregion)
References: <20131129134535.f886fbf966dcfea00178a1b7@canb.auug.org.au>
In-Reply-To: <20131129134535.f886fbf966dcfea00178a1b7@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13 18:45, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20131128:
> 

on x86_64:

CONFIG_ACPI is not enabled.


  CC      drivers/gpu/drm/i915/intel_opregion.o
In file included from drivers/gpu/drm/i915/intel_opregion.c:31:0:
include/linux/acpi_io.h:7:45: error: unknown type name 'acpi_physical_address'
include/linux/acpi_io.h:8:10: error: unknown type name 'acpi_size'
include/linux/acpi_io.h:13:33: error: unknown type name 'acpi_physical_address'
include/linux/acpi_io.h:15:40: warning: 'struct acpi_generic_address' declared inside parameter list [enabled by default]
include/linux/acpi_io.h:15:40: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/acpi_io.h:16:43: warning: 'struct acpi_generic_address' declared inside parameter list [enabled by default]
drivers/gpu/drm/i915/intel_opregion.c: In function 'intel_opregion_setup':
drivers/gpu/drm/i915/intel_opregion.c:866:2: error: implicit declaration of function 'acpi_os_ioremap' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/intel_opregion.c:866:7: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[5]: *** [drivers/gpu/drm/i915/intel_opregion.o] Error 1


-- 
~Randy
