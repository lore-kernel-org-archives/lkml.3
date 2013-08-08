Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab3HHAwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 20:52:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563Ab3HHAwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 20:52:15 -0400
Date: Wed, 7 Aug 2013 20:50:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, gleb@redhat.com, mingo@redhat.com,
        jeremy@goop.org, x86@kernel.org, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH  V12 0/14] Paravirtualized ticket spinlocks
Message-ID: <20130808005012.GI2810@phenom.dumpdata.com>
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
 <52016412.1020608@zytor.com>
 <5201B6FB.5080807@linux.vnet.ibm.com>
 <5201D180.9080005@zytor.com>
 <5201ED01.7000803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5201ED01.7000803@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 12:15:21PM +0530, Raghavendra K T wrote:
> On 08/07/2013 10:18 AM, H. Peter Anvin wrote:
> >>Please let me know, if I should rebase again.
> >>
> >
> >tip:master is not a stable branch; it is more like linux-next.  We need
> >to figure out which topic branches are dependencies for this set.
> 
> Okay. I 'll start looking at the branches that would get affected.
> (Xen, kvm are obvious ones).
> Please do let me know the branches I might have to check for.

>From the Xen standpoint anything past v3.11-rc4 would work.

> 
> 
> 
> 
> 
