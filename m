Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbaGINzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:55:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38435 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaGINza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:55:30 -0400
Date: Wed, 9 Jul 2014 09:55:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v2] xen: Introduce 'xen_nopv' to disable PV
 extensions for HVM guests.
Message-ID: <20140709135519.GB21837@laptop.dumpdata.com>
References: <1404852745-25187-1-git-send-email-konrad@kernel.org>
 <53BD311B.2050404@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD311B.2050404@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:10:03PM +0100, David Vrabel wrote:
> On 08/07/14 21:52, konrad@kernel.org wrote:
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > By default when CONFIG_XEN and CONFIG_XEN_PVHVM kernels are
> > run, they will enable the PV extensions (drivers, interrupts, timers,
> > etc) - which is perfect.
> 
> If it's "perfect" what's this option for? ;)

:-)
> 
> I think you mean to say "which is the best option for the majority of
> use cases".

Yes!
> 
> > However, in some cases (kexec not fully wokring, benchmarking)
> > we want to disable Xen PV extensions. As such introduce the
> > 'xen_nopv' parameter that will do it.
> 
> "working"
> 
> I'm unconvinced about the utility of this option.  The resulting kernel
> will go like molasses and I'm not sure what the use of being any to
> benchmark a configuration no one will use in practice.  But it's a small
> patch so
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thank you.

> 
> David
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
