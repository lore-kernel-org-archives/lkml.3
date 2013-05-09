Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3EIIND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:13:03 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:43542 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3EIINA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:13:00 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4386351"
Message-ID: <1368087178.17285.87.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v3 1/4] xen: move xen_setup_runstate_info
 and get_runstate_snapshot to drivers/xen/time.c
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 9 May 2013 09:12:58 +0100
In-Reply-To: <alpine.DEB.2.02.1305081858220.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com>
	 <1368027714-14506-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20130508175444.GB2800@phenom.dumpdata.com>
	 <alpine.DEB.2.02.1305081858220.18865@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-08 at 19:13 +0100, Stefano Stabellini wrote:
> On Wed, 8 May 2013, Konrad Rzeszutek Wilk wrote:
> > On Wed, May 08, 2013 at 04:41:51PM +0100, Stefano Stabellini wrote:
> > > Changes in v2:
> > > - leave do_stolen_accounting in arch/x86/xen/time.c;
> > > - use the new common functions in arch/ia64/xen/time.c.
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > > CC: konrad.wilk@oracle.com
> > 
> > On the generic and x86 side it looks OK to me. I presume you did a sanity
> > check on x86 to make sure nothing was off?
> 
> Yep, it seems to work.
> However I couldn't even compile test the ia64 code.

The ia64 Xen on Linux support hasn't been touched since circa 2.6.35
AFAIK...

Ian.

