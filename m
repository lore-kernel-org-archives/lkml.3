Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaCYMMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:12:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:65302 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaCYMMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:12:31 -0400
X-IronPort-AV: E=Sophos;i="4.97,728,1389744000"; 
   d="scan'208";a="113301881"
Date: Tue, 25 Mar 2014 12:12:01 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "nico@linaro.org" <nico@linaro.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v9 4/5] arm64: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING
 and pv_time_ops
In-Reply-To: <53316D0F.7040600@arm.com>
Message-ID: <alpine.DEB.2.02.1403251211540.20389@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1401091755390.21510@kaball.uk.xensource.com> <1389292336-9292-4-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1402171225000.27926@kaball.uk.xensource.com> <20140217175552.GB8361@arm.com>
 <alpine.DEB.2.02.1403251119050.8273@kaball.uk.xensource.com> <53316D0F.7040600@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Marc Zyngier wrote:
> On 25/03/14 11:19, Stefano Stabellini wrote:
> > On Mon, 17 Feb 2014, Catalin Marinas wrote:
> >> On Mon, Feb 17, 2014 at 12:25:42PM +0000, Stefano Stabellini wrote:
> >>> On Thu, 9 Jan 2014, Stefano Stabellini wrote:
> >>>> Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM64.
> >>>> Necessary duplication of paravirt.h and paravirt.c with ARM.
> >>>>
> >>>> The only paravirt interface supported is pv_time_ops.steal_clock, so no
> >>>> runtime pvops patching needed.
> >>>>
> >>>> This allows us to make use of steal_account_process_tick for stolen
> >>>> ticks accounting.
> >>>>
> >>>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >>>> CC: will.deacon@arm.com
> >>>> CC: nico@linaro.org
> >>>> CC: marc.zyngier@arm.com
> >>>> CC: cov@codeaurora.org
> >>>> CC: arnd@arndb.de
> >>>> CC: olof@lixom.net
> >>>> CC: Catalin.Marinas@arm.com
> >>>
> >>> Catalin, Will, are you happy with this patch for 3.15?
> >>
> >> It's pretty small and looks fine to me. However, I would like someone
> >> with more virtualisation experience than me to ack it (e.g. Marc Z).
> > 
> > Ping? Marc, could you please give it a review?
> 
> Yup, that looks OK to me. It's a generic feature anyway, so I don't see
> any harm in enabling it for Xen. We may also use it for KVM at some point.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks!
