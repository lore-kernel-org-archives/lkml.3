Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab3EHQN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:13:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21477 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3EHQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:13:57 -0400
Date: Wed, 8 May 2013 12:13:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, fenghua.yu@intel.com,
        xen-devel@lists.xensource.com
Subject: Re: v3.9 - CPU hotplug and microcode earlier loading hits a mutex
 deadlock (x86_cpu_hotplug_driver_mutex)
Message-ID: <20130508161328.GA15823@phenom.dumpdata.com>
References: <20130506125937.GA14036@phenom.dumpdata.com>
 <20130507190024.GA4303@phenom.dumpdata.com>
 <20130508125414.GB30955@pd.tnic>
 <20130508140342.GA8152@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508140342.GA8152@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > The comment for calling save_mc_for_early says:
> > 
> > Looks like save_mc_for_early would need another, local mutex to fix that.
> 
> Let me try that. Thanks for the suggestion.

Looks to work nicely. Just posted a patch for this.
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > Sent from a fat crate under my desk. Formatting is fine.
> > --
