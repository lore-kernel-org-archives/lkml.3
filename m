Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab3BTHFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:05:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:45773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab3BTHFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:05:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,700,1355068800"; 
   d="scan'208";a="6734705"
Subject: Re: [PATCH v4 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com
In-Reply-To: <alpine.DEB.2.02.1302192254440.27407@chino.kir.corp.google.com>
References: <1360894992-14818-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1360894992-14818-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302191320410.6322@chino.kir.corp.google.com>
	 <1361324355.7859.35.camel@liguang.fnst.cn.fujitsu.com>
	 <1361325113.7859.37.camel@liguang.fnst.cn.fujitsu.com>
	 <alpine.DEB.2.02.1302191802490.14999@chino.kir.corp.google.com>
	 <1361326913.7859.41.camel@liguang.fnst.cn.fujitsu.com>
	 <1361327201.7859.44.camel@liguang.fnst.cn.fujitsu.com>
	 <alpine.DEB.2.02.1302191902470.18957@chino.kir.corp.google.com>
	 <1361330196.7859.51.camel@liguang.fnst.cn.fujitsu.com>
	 <alpine.DEB.2.02.1302192254440.27407@chino.kir.corp.google.com>
Date: Wed, 20 Feb 2013 15:05:26 +0800
Message-ID: <1361343926.7859.53.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 15:04:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 15:04:36,
	Serialize complete at 2013/02/20 15:04:36
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-19二的 23:00 -0800，David Rientjes写道：
> On Wed, 20 Feb 2013, li guang wrote:
> 
> > Yes, I know there's no new changes in my patch as I said before(not
> > based on lasted), but as I try to apply my patch(1/4), it will do
> > the right work to move current srat.c from arch/x86/mm/ to
> > arch/x86/kernel/acpi/ regardless of what I based is not latest.
> > 
> 
> Sorry, but that makes no sense.  Your patch cannot be used cleanly if 
> there have been subsequent changes to a hunk prior to applying it -- in 
> this case the hunk would be the entire file since you're removing it.
> 
> These patches would also be pushed by the x86 maintainers, who are not 
> cc'd on this patch, and I think it would be unfair to ask them to make up 
> for your inability to generate a bleeding edge patch with linux-next.  The 
> changes already cited in this thread have been in linux-next for almost 
> two weeks, yet you refuse to rebase on top of them.

OK, I'd like to rebase,
Thanks!


