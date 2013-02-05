Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3BEF5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:57:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44015 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3BEF5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:57:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6690303"
Subject: Re: [PATCH v2 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
In-Reply-To: <alpine.DEB.2.02.1302042131400.31498@chino.kir.corp.google.com>
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1360031838-26898-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302042131400.31498@chino.kir.corp.google.com>
Date: Tue, 05 Feb 2013 13:45:02 +0800
Message-ID: <1360043102.4449.12.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:43:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:56:25,
	Serialize complete at 2013/02/05 13:56:25
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-04一的 21:35 -0800，David Rientjes写道：
> On Tue, 5 Feb 2013, liguang wrote:
> 
> > srat table should present only on acpi domain,
> > seems mm/ is not the right place for it.
> > 
> > Reviewed-by: David Rientjes <rientjes@google.com>
> 
> I certainly didn't review this, please read 
> Documentation/SubmittingPatches.
> 
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> 
> Couple of issues with this:
> 
>  - it doesn't include your followup change "acpi: change Makefile for
>    srat.c building" which is required for this to build, please fold it in 
>    and repost,
> 
>  - there is whitespace damage, we use tabs for indentation in Makefiles,
> 
>  - you're basing your patches on Linus' tree when arch/x86/mm/srat has
>    changed in linux-next (15 insertions(+), 14 deletions(-)), please 
>    rebase this on the linux-next tree at git.kernel.org.
> 
> Otherwise, looks good.

OK, I'll rebase on linux-next.
Thanks!


