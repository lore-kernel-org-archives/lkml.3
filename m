Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab3GPQcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:32:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab3GPQcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:32:15 -0400
Date: Tue, 16 Jul 2013 19:31:04 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, mingo@redhat.com,
        jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com, hpa@zytor.com,
        pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephan.diestelhorst@amd.com, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
Message-ID: <20130716163104.GD8981@redhat.com>
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com>
 <20130624124342.27508.44656.sendpatchset@codeblue.in.ibm.com>
 <20130714131241.GA11772@redhat.com>
 <51E3C5CE.7000009@linux.vnet.ibm.com>
 <20130715103648.GN11772@redhat.com>
 <51E4C011.4060803@linux.vnet.ibm.com>
 <20130716060215.GE11772@redhat.com>
 <20130716154852.GN23818@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716154852.GN23818@dyad.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 05:48:52PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 16, 2013 at 09:02:15AM +0300, Gleb Natapov wrote:
> > BTW can NMI handler take spinlocks? 
> 
> No -- that is, yes you can using trylock, but you still shouldn't.
> 
Great news for this code. Thanks.

--
			Gleb.
