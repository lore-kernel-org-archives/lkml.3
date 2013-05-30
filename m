Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967777Ab3E3HUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:20:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13412 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967578Ab3E3HUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:20:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,769,1363104000"; 
   d="scan'208";a="7410598"
Subject: Re: [PATCH] powerpc/pseries: use 'true' instead of '1' for
 orderly_poweroff
From: li guang <lig.fnst@cn.fujitsu.com>
To: Joe Perches <joe@perches.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1369898064.22004.134.camel@joe-AO722>
References: <1369897651-23770-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1369898064.22004.134.camel@joe-AO722>
Date: Thu, 30 May 2013 15:20:06 +0800
Message-ID: <1369898406.15177.38.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:19:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:19:12,
	Serialize complete at 2013/05/30 15:19:12
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-05-30四的 00:14 -0700，Joe Perches写道：
> On Thu, 2013-05-30 at 15:07 +0800, liguang wrote:
> > orderly_poweroff is expecting a bool parameter, so
> > use 'ture' instead '1'
> []
> > diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
> []
> > @@ -162,7 +162,7 @@ void rtas_parse_epow_errlog(struct rtas_error_log *log)
> >  
> >  	case EPOW_SYSTEM_HALT:
> >  		pr_emerg("Firmware initiated power off");
> > -		orderly_poweroff(1);
> > +		orderly_poweroff(ture);
> >  		break;
> 
> Compile your patches _before_ submitting them please.
> 
> "true" not "ture" here and in the commit message.
> 

right, thanks!


