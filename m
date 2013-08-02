Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab3HBJZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:25:50 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:41220 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab3HBJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:25:44 -0400
Date: Fri, 2 Aug 2013 11:25:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, mingo@redhat.com, x86@kernel.org,
        tglx@linutronix.de, jeremy@goop.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
Message-ID: <20130802092539.GB28327@gmail.com>
References: <20130724103907.GF16400@redhat.com>
 <51EFC1D4.9060800@linux.vnet.ibm.com>
 <20130724120647.GG16400@redhat.com>
 <51EFCA42.5020009@linux.vnet.ibm.com>
 <51F0ED31.3040200@linux.vnet.ibm.com>
 <20130725091509.GA22735@redhat.com>
 <51F0F202.5090001@linux.vnet.ibm.com>
 <51F7ED20.80202@linux.vnet.ibm.com>
 <20130731062440.GK28372@redhat.com>
 <51FA1087.9080908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FA1087.9080908@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> On 07/31/2013 11:54 AM, Gleb Natapov wrote:
> >On Tue, Jul 30, 2013 at 10:13:12PM +0530, Raghavendra K T wrote:
> >>On 07/25/2013 03:08 PM, Raghavendra K T wrote:
> >>>On 07/25/2013 02:45 PM, Gleb Natapov wrote:
> >>>>On Thu, Jul 25, 2013 at 02:47:37PM +0530, Raghavendra K T wrote:
> >>>>>On 07/24/2013 06:06 PM, Raghavendra K T wrote:
> >>>>>>On 07/24/2013 05:36 PM, Gleb Natapov wrote:
> >>>>>>>On Wed, Jul 24, 2013 at 05:30:20PM +0530, Raghavendra K T wrote:
> >>>>>>>>On 07/24/2013 04:09 PM, Gleb Natapov wrote:
> >>>>>>>>>On Wed, Jul 24, 2013 at 03:15:50PM +0530, Raghavendra K T wrote:
> >>>>>>>>>>On 07/23/2013 08:37 PM, Gleb Natapov wrote:
> >>>>>>>>>>>On Mon, Jul 22, 2013 at 11:50:16AM +0530, Raghavendra K T wrote:
> >>>>>>>>>>>>+static void kvm_lock_spinning(struct arch_spinlock *lock,
> >>>>>>>>>>>>__ticket_t want)
> >>>>>>>>>>[...]

[ a few hundred lines of unnecessary quotation snipped. ]

> Ingo,
> 
> Do you have any concerns reg this series? please let me know if this 
> looks good now to you.

I'm inclined to NAK it for excessive quotation - who knows how many people 
left the discussion in disgust? Was it done to drive away as many 
reviewers as possible?

Anyway, see my other reply, the measurement results seem hard to interpret 
and inconclusive at the moment.

Thanks,

	Ingo
