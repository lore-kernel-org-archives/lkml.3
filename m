Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbbAWS6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:58:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbbAWS6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:58:47 -0500
Date: Fri, 23 Jan 2015 19:58:45 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [Xen-devel] [RFC v4 0/2] x86/xen: add xen hypercall preemption
Message-ID: <20150123185845.GY17887@wotan.suse.de>
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <54C235AD.5010202@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C235AD.5010202@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 11:51:09AM +0000, David Vrabel wrote:
> On 23/01/15 00:29, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > This v4 addresses some of the cleanups recommended and adds
> > tracing option for when we do actually preempt a hypercall.
> > I kept the NOKPROBE_SYMBOL() for now but did remove the 'notrace'
> > stuff.
> > 
> > This goes out as RFC still as I have not been able to test 32-bit.
> > Can anyone test that or at least confirm that the 32-bit point
> > we do the upcall is definitely not on the IRQ stack?
> 
> You can omit fixing this for 32-bit guests (provided you note as such in
> the commit message).

I'll be happy to do that.

 Luis
