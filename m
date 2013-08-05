Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3HEPjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:39:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42679 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3HEPi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:38:58 -0400
Date: Mon, 5 Aug 2013 11:37:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Gleb Natapov <gleb@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, mingo@redhat.com,
        x86@kernel.org, tglx@linutronix.de, jeremy@goop.org, hpa@zytor.com,
        pbonzini@redhat.com, linux-doc@vger.kernel.org,
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
Message-ID: <20130805153734.GJ3321@phenom.dumpdata.com>
References: <51EFCA42.5020009@linux.vnet.ibm.com>
 <51F0ED31.3040200@linux.vnet.ibm.com>
 <20130725091509.GA22735@redhat.com>
 <51F0F202.5090001@linux.vnet.ibm.com>
 <51F7ED20.80202@linux.vnet.ibm.com>
 <20130731062440.GK28372@redhat.com>
 <51FA1087.9080908@linux.vnet.ibm.com>
 <20130802092539.GB28327@gmail.com>
 <20130802095406.GB30072@redhat.com>
 <20130805094603.GA29303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805094603.GA29303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 11:46:03AM +0200, Ingo Molnar wrote:
> 
> * Gleb Natapov <gleb@redhat.com> wrote:
> 
> > On Fri, Aug 02, 2013 at 11:25:39AM +0200, Ingo Molnar wrote:
> > > > Ingo,
> > > > 
> > > > Do you have any concerns reg this series? please let me know if this 
> > > > looks good now to you.
> > > 
> > > I'm inclined to NAK it for excessive quotation - who knows how many 
> > > people left the discussion in disgust? Was it done to drive away as 
> > > many reviewers as possible?
> > > 
> > > Anyway, see my other reply, the measurement results seem hard to 
> > > interpret and inconclusive at the moment.
> >
> > That result was only for patch 18 of the series, not pvspinlock in 
> > general.
> 
> Okay - I've re-read the performance numbers and they are impressive, so no 
> objections from me.
> 
> The x86 impact seems to be a straightforward API change, with most of the 
> changes on the virtualization side. So:
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> I guess you'd want to carry this in the KVM tree or so - maybe in a 
> separate branch because it changes Xen as well?

May I suggest an alternate way - perhaps you can put them in a tip/spinlock
tree for v3.12 - since both KVM and Xen maintainers have acked and carefully
reviewed them?
