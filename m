Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaAUSTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:19:04 -0500
Received: from smtp.citrix.com ([66.165.176.89]:11991 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377AbaAUSSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:18:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,696,1384300800"; 
   d="scan'208";a="95004393"
Date: Tue, 21 Jan 2014 18:17:47 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH v4] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build
 dependencies for XEN
In-Reply-To: <20140121180750.GO30706@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1401211817350.21510@kaball.uk.xensource.com>
References: <1390311864-19119-1-git-send-email-stefano.stabellini@eu.citrix.com> <20140121180750.GO30706@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Will Deacon wrote:
> On Tue, Jan 21, 2014 at 01:44:24PM +0000, Stefano Stabellini wrote:
> > Remove !GENERIC_ATOMIC64 build dependency:
> > - introduce xen_atomic64_xchg
> > - use it to implement xchg_xen_ulong
> > 
> > Remove !CPU_V6 build dependency:
> > - introduce __cmpxchg8 and __cmpxchg16, compiled even ifdef
> >   CONFIG_CPU_V6
> > - implement sync_cmpxchg using __cmpxchg8 and __cmpxchg16
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: arnd@arndb.de
> > CC: linux@arm.linux.org.uk
> > CC: will.deacon@arm.com
> > CC: catalin.marinas@arm.com
> > CC: linux-arm-kernel@lists.infradead.org
> > CC: linux-kernel@vger.kernel.org
> > CC: xen-devel@lists.xenproject.org
> 
>   Reviewed-by: Will Deacon <will.deacon@arm.com>
> 
> Cheers Stefano,

Thanks!!
