Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab3EHSNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:13:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45914 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010Ab3EHSNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:13:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,636,1363132800"; 
   d="scan'208";a="24083910"
Date: Wed, 8 May 2013 19:13:00 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>
Subject: Re: [PATCH v3 1/4] xen: move xen_setup_runstate_info and
 get_runstate_snapshot to drivers/xen/time.c
In-Reply-To: <20130508175444.GB2800@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1305081858220.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com> <1368027714-14506-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130508175444.GB2800@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, May 08, 2013 at 04:41:51PM +0100, Stefano Stabellini wrote:
> > Changes in v2:
> > - leave do_stolen_accounting in arch/x86/xen/time.c;
> > - use the new common functions in arch/ia64/xen/time.c.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > CC: konrad.wilk@oracle.com
> 
> On the generic and x86 side it looks OK to me. I presume you did a sanity
> check on x86 to make sure nothing was off?

Yep, it seems to work.
However I couldn't even compile test the ia64 code.
