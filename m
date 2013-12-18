Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3LRPGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:06:25 -0500
Received: from smtp.citrix.com ([66.165.176.89]:22928 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab3LRPGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:06:24 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85765743"
Date: Wed, 18 Dec 2013 15:05:46 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 03/12] xen/pvh: Early bootup changes in
 PV code.
In-Reply-To: <20131218145852.GC4934@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1312181505180.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-4-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312181423380.8667@kaball.uk.xensource.com> <20131218145852.GC4934@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > If so, does it make sense to check for it at run time too?
> > 
> 
> I think I might as well rip that out - as that code won't be ever
> touched. And perhaps just stash in a BUG with /* PVH: FIXME */?

That would be fine.
