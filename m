Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661Ab3BYCdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:33:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:31414 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759532Ab3BYCdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:33:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,731,1355068800"; 
   d="scan'208";a="6760613"
Subject: Re: [rebased][PATCH 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <alpine.DEB.2.02.1302221255240.11248@chino.kir.corp.google.com>
References: <1361511887-29241-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1361511887-29241-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302221255240.11248@chino.kir.corp.google.com>
Date: Mon, 25 Feb 2013 10:32:20 +0800
Message-ID: <1361759540.2262.8.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/25 10:32:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/25 10:32:22,
	Serialize complete at 2013/02/25 10:32:22
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-22五的 12:57 -0800，David Rientjes写道：
> On Fri, 22 Feb 2013, liguang wrote:
> 
> > srat table should present only on acpi domain,
> > seems mm/ is not the right place for it.
> > 
> > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> 
> This is not rebased, it does not have 4819e14ff31e ("acpi, movablemem_map: 
> Set numa_nodes_hotplug nodemask when using SRAT info.") but does have 
> f7c24b7e1c41 ("acpi, memory-hotplug: support getting hotplug info from 
> SRAT"), so I don't know how you're generating these patches.
> 
> You're also not sending this to any maintainer who would merge it, so 
> please run scripts/get_maintainer.pl on it.

my linux-next repo will not always be latest for inconvenient network
service. 


