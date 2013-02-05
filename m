Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3BEBRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:17:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41005 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab3BEBRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:17:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6688711"
Subject: Re: [PATCH 3/5] acpi: move x86/mm/srat.c to x86/kernel/acpi/srat.c
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
In-Reply-To: <alpine.DEB.2.02.1302041142550.10378@chino.kir.corp.google.com>
References: <1359967426-32629-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1359967426-32629-4-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302041142550.10378@chino.kir.corp.google.com>
Date: Tue, 05 Feb 2013 09:16:57 +0800
Message-ID: <1360027017.4449.9.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 09:15:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 09:15:56,
	Serialize complete at 2013/02/05 09:15:56
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-04一的 11:44 -0800，David Rientjes写道：
> On Mon, 4 Feb 2013, liguang wrote:
> 
> > srat table should present only on acpi domain,
> > seems mm/ is not the right place for it.
> > 
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> > ---
> >  arch/x86/kernel/acpi/Makefile |    1 +
> >  arch/x86/mm/Makefile          |    1 -
> >  arch/x86/mm/srat.c            |  191 -----------------------------------------
> >  3 files changed, 1 insertions(+), 192 deletions(-)
> >  delete mode 100644 arch/x86/mm/srat.c
> > 
> 
> I was excited for a moment because this would have been one great cleanup, 
> but you never readded the code to arch/x86/kernel/acpi.  (You probably 
> need to do "git add <newfile>" before generating the patch file.)  I do 
> like the idea of moving it, though, if it's build tested thoroughly.

OK, will git add it.


