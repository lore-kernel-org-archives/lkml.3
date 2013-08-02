Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3HBJzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758487Ab3HBJzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:55:16 -0400
Date: Fri, 2 Aug 2013 12:54:06 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, mingo@redhat.com,
        x86@kernel.org, tglx@linutronix.de, jeremy@goop.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        drjones@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
Message-ID: <20130802095406.GB30072@redhat.com>
References: <51EFC1D4.9060800@linux.vnet.ibm.com>
 <20130724120647.GG16400@redhat.com>
 <51EFCA42.5020009@linux.vnet.ibm.com>
 <51F0ED31.3040200@linux.vnet.ibm.com>
 <20130725091509.GA22735@redhat.com>
 <51F0F202.5090001@linux.vnet.ibm.com>
 <51F7ED20.80202@linux.vnet.ibm.com>
 <20130731062440.GK28372@redhat.com>
 <51FA1087.9080908@linux.vnet.ibm.com>
 <20130802092539.GB28327@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802092539.GB28327@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 11:25:39AM +0200, Ingo Molnar wrote:
> > Ingo,
> > 
> > Do you have any concerns reg this series? please let me know if this 
> > looks good now to you.
> 
> I'm inclined to NAK it for excessive quotation - who knows how many people 
> left the discussion in disgust? Was it done to drive away as many 
> reviewers as possible?
> 
> Anyway, see my other reply, the measurement results seem hard to interpret 
> and inconclusive at the moment.
> 
That result was only for patch 18 of the series, not pvspinlock in
general.

--
			Gleb.
