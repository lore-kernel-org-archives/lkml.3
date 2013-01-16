Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3APWnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:43:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42239 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709Ab3APWnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:43:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad@kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] fixes to ACPI subsystem which assumes cpuidle is always enabled.
Date: Wed, 16 Jan 2013 23:49 +0100
Message-ID: <1449747.HgoeXlbhzH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358288604-24620-1-git-send-email-konrad.wilk@oracle.com>
References: <1358288604-24620-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 15, 2013 05:23:22 PM Konrad Rzeszutek Wilk wrote:
> Attached are two patches to the ACPI subsystem and the cpuidle drivers.
> 
> The fixes are to deal with the case when cpuidle_disabled returns true
> and we try to hotplug CPUs on/off. 
> 
>  drivers/acpi/processor_idle.c | 3 +++
>  drivers/idle/intel_idle.c     | 3 +--
>  2 files changed, 4 insertions(+), 2 deletions(-)

Both patches applied.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
