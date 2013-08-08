Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab3HHBD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 21:03:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458Ab3HHBDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 21:03:55 -0400
Date: Thu, 8 Aug 2013 04:02:51 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, jeremy@goop.org,
        x86@kernel.org, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH  V12 0/14] Paravirtualized ticket spinlocks
Message-ID: <20130808010251.GJ15901@redhat.com>
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
 <52016412.1020608@zytor.com>
 <5201B6FB.5080807@linux.vnet.ibm.com>
 <5201D180.9080005@zytor.com>
 <5201ED01.7000803@linux.vnet.ibm.com>
 <20130808005012.GI2810@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808005012.GI2810@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 08:50:12PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 07, 2013 at 12:15:21PM +0530, Raghavendra K T wrote:
> > On 08/07/2013 10:18 AM, H. Peter Anvin wrote:
> > >>Please let me know, if I should rebase again.
> > >>
> > >
> > >tip:master is not a stable branch; it is more like linux-next.  We need
> > >to figure out which topic branches are dependencies for this set.
> > 
> > Okay. I 'll start looking at the branches that would get affected.
> > (Xen, kvm are obvious ones).
> > Please do let me know the branches I might have to check for.
> 
> >From the Xen standpoint anything past v3.11-rc4 would work.
> 
For KVM as early as past v3.11-rc1 would be OK.

--
			Gleb.
