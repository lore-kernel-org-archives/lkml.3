Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaC0C4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:56:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:50818 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaC0C4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:56:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,739,1389772800"; 
   d="scan'208";a="500552554"
Date: Thu, 27 Mar 2014 10:56:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [KVM] BUG: unable to handle kernel NULL pointer dereference at
 00000000000002b0
Message-ID: <20140327025641.GA12099@localhost>
References: <20140326144053.GC26721@localhost>
 <5332E94B.3050407@redhat.com>
 <20140326145701.GA27938@localhost>
 <5332F668.8080601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5332F668.8080601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 04:46:48PM +0100, Paolo Bonzini wrote:
> Il 26/03/2014 15:57, Fengguang Wu ha scritto:
> >>>> >
> >>>> >git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> >>>> >commit 93c4adc7afedf9b0ec190066d45b6d67db5270da ("KVM: x86: handle missing MPX in nested virtualization")
> >>>
> >>> Ouch.  Out of curiosity is this on Skylake prototypes, or is it also
> >>> visible on some released silicon?
> >Paolo, the problem shows up in a Sandybridge-EX and an Ivybridge-EX.
> 
> What does that mean in terms of commercial names?  I tested on Sandy
> Bridge Xeon E5.

Sorry I don't know the exact commercial names listed in

http://en.wikipedia.org/wiki/Sandy_Bridge
http://en.wikipedia.org/wiki/Ivy_Bridge_%28microarchitecture%29

Thanks,
Fengguang
