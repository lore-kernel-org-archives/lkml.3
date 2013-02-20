Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab3BTBjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:39:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44764 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757174Ab3BTBjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:39:09 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355068800"; 
   d="scan'208";a="6731899"
Subject: Re: [PATCH v4 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com
In-Reply-To: <alpine.DEB.2.02.1302191320410.6322@chino.kir.corp.google.com>
References: <1360894992-14818-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1360894992-14818-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302191320410.6322@chino.kir.corp.google.com>
Date: Wed, 20 Feb 2013 09:39:15 +0800
Message-ID: <1361324355.7859.35.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 09:38:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 09:38:28,
	Serialize complete at 2013/02/20 09:38:28
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-19二的 13:21 -0800，David Rientjes写道：
> On Fri, 15 Feb 2013, liguang wrote:
> 
> > srat table should present only on acpi domain,
> > seems mm/ is not the right place for it.
> > 
> > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> 
> This doesn't apply to Linus' tree nor does it apply to linux-next.  Which 
> tree are you basing this on?

I did based on linux-next, 
but it seems without commit 479a99a8e510c8839e0d3d3de8391f8bc61b9760
which you may want to see.
let me see why it missed.



