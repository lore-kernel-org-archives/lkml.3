Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab3DIAYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 20:24:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64625 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763013Ab3DIAYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 20:24:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,435,1363104000"; 
   d="scan'208";a="7017445"
Subject: Re: [rebased-again][PATCH 0/4] acpi: do some changes for numa info
From: li guang <lig.fnst@cn.fujitsu.com>
To: tglx@linutronix.de
Cc: hpa@zytor.com, pavel@ucw.cz, rjw@sisk.pl, lv.zheng@intel.com,
        jarkko.sakkinen@intel.com, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <1362360079.19928.1.camel@liguang.fnst.cn.fujitsu.com>
References: <1361759917-5195-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1362360079.19928.1.camel@liguang.fnst.cn.fujitsu.com>
Date: Tue, 09 Apr 2013 08:23:09 +0800
Message-ID: <1365466989.9553.1.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 08:23:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 08:23:06,
	Serialize complete at 2013/04/09 08:23:06
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ...

在 2013-03-04一的 09:21 +0800，li guang写道：
> Hi, Thomas, Peter, Ingo
> 
> can you help to merge these 4 patches?
> or do you have any other comments?
> 
> 
> 在 2013-02-25一的 10:38 +0800，liguang写道：
> > just do some trivial changes to make acpi's numa info
> > operation more cleaner.
> > 
> > ChangeLog
> > 
> > v3->v4
> >  1.fix srat_disabled function
> >  spotted by Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > 
> > v2->v3
> >  1. rebase on linux-next
> >  2. bring back lost Makefile changes
> >  spotted by David Rientjes <rientjes@google.com>
> >  spotted by Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > 
> > v1->v2
> >  1. fix-up several coding issues
> >  2. finish srat.c change
> >  spotted by David Rientjes <rientjes@google.com>
> > 
> > Li Guang (4)
> > 	 acpi: move x86/mm/srat.c to x86/kernel/acpi/srat.c
> > 	 numa: avoid export acpi_numa variable
> > 	 acpi: add clock_domain field to acpi_srat_cpu_affinity
> > 	 remove include asm/acpi.h in process_driver.c
> > 
> > arch/x86/include/asm/acpi.h     | 2 +-
> > arch/x86/kernel/acpi/Makefile   | 1 +
> > arch/x86/kernel/acpi/srat.c     | 299 +++++++++++++++++++++++++++++++++++++++++
> > arch/x86/mm/Makefile            | 1 -
> > arch/x86/mm/numa.c              | 2 +-
> > arch/x86/mm/srat.c              | 278 -----------------------------------------
> > arch/x86/xen/enlighten.c        | 2 +-
> > drivers/acpi/processor_driver.c | 1 -
> > include/acpi/actbl1.h           | 2 +-
> > 9 files changed, 296 insertions(+), 292 deletions(-)
> >  create mode 100644 arch/x86/kernel/acpi/srat.c
> >  delete mode 100644 arch/x86/mm/srat.c
> >  
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 


