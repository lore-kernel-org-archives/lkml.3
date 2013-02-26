Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964Ab3BZBCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:02:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9660 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757644Ab3BZBCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:02:01 -0500
X-IronPort-AV: E=Sophos;i="4.84,737,1355068800"; 
   d="scan'208";a="6767466"
Subject: Re: [rebased-again][PATCH 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: tglx@linutronix.de, hpa@zytor.com, pavel@ucw.cz, rjw@sisk.pl,
        lv.zheng@intel.com, jarkko.sakkinen@intel.com, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <alpine.DEB.2.02.1302251450160.4488@chino.kir.corp.google.com>
References: <1361759917-5195-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1361759917-5195-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302251450160.4488@chino.kir.corp.google.com>
Date: Tue, 26 Feb 2013 09:01:04 +0800
Message-ID: <1361840464.2262.25.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 09:01:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 09:01:10,
	Serialize complete at 2013/02/26 09:01:10
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-25一的 14:51 -0800，David Rientjes写道：
> On Mon, 25 Feb 2013, liguang wrote:
> 
> > srat table should present only on acpi domain,
> > seems mm/ is not the right place for it.
> > 
> > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> 
> You're still missing 01a178a94e8e ("acpi, memory-hotplug: support getting 
> hotplug info from SRAT") that was merged at the end of last week.  Instead 
> of continuing to rebase perhaps it would be better at this point to ask 
> the x86 maintainers to just do the patch for you?

maybe I have to ask them to help generate this patch,
I pulled latest since 25th, Feb, and re-generate this patch,
and it did have the commit you've pointed out.
Thanks!

