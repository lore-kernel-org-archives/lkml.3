Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3CAAha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:37:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab3CAAh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:37:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,758,1355068800"; 
   d="scan'208";a="6789858"
Subject: Re: [rebased][PATCH 0/4] acpi: do some changes for numa info
From: li guang <lig.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: rientjes@google.com, x86@kernel.org
In-Reply-To: <1361511887-29241-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1361511887-29241-1-git-send-email-lig.fnst@cn.fujitsu.com>
Date: Fri, 01 Mar 2013 08:37:05 +0800
Message-ID: <1362098225.2262.47.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 08:36:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 08:36:32,
	Serialize complete at 2013/03/01 08:36:32
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can anyone help to merge these patches?
or any other comments?

在 2013-02-22五的 13:44 +0800，liguang写道：
> just do some trivial changes to make acpi's numa info
> operation more cleaner.
> 
> ChangeLog
> 
> v3->v4
>  1.fix srat_disabled function
>  spotted by Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> v2->v3
>  1. rebase on linux-next
>  2. bring back lost Makefile changes
>  spotted by David Rientjes <rientjes@google.com>
>  spotted by Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> v1->v2
>  1. fix-up several coding issues
>  2. finish srat.c change
>  spotted by David Rientjes <rientjes@google.com>
> 
> Li Guang (4)
> 	 acpi: move x86/mm/srat.c to x86/kernel/acpi/srat.c
> 	 numa: avoid export acpi_numa variable
> 	 acpi: add clock_domain field to acpi_srat_cpu_affinity
> 	 remove include asm/acpi.h in process_driver.c
> 
> arch/x86/include/asm/acpi.h     | 2 +-
> arch/x86/kernel/acpi/Makefile   | 1 +
> arch/x86/kernel/acpi/srat.c     | 299 +++++++++++++++++++++++++++++++++++++++++
> arch/x86/mm/Makefile            | 1 -
> arch/x86/mm/numa.c              | 2 +-
> arch/x86/mm/srat.c              | 278 -----------------------------------------
> arch/x86/xen/enlighten.c        | 2 +-
> drivers/acpi/processor_driver.c | 1 -
> include/acpi/actbl1.h           | 2 +-
> 9 files changed, 296 insertions(+), 292 deletions(-)
>  create mode 100644 arch/x86/kernel/acpi/srat.c
>  delete mode 100644 arch/x86/mm/srat.c
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


