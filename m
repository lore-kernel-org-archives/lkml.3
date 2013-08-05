Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3HENwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:52:30 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:51869 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3HENw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:52:27 -0400
Date: Mon, 5 Aug 2013 15:52:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Gleb Natapov <gleb@redhat.com>
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
Message-ID: <20130805135222.GA32429@gmail.com>
References: <51F0ED31.3040200@linux.vnet.ibm.com>
 <20130725091509.GA22735@redhat.com>
 <51F0F202.5090001@linux.vnet.ibm.com>
 <51F7ED20.80202@linux.vnet.ibm.com>
 <20130731062440.GK28372@redhat.com>
 <51FA1087.9080908@linux.vnet.ibm.com>
 <20130802092539.GB28327@gmail.com>
 <20130802095406.GB30072@redhat.com>
 <20130805094603.GA29303@gmail.com>
 <20130805095901.GL2258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805095901.GL2258@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gleb Natapov <gleb@redhat.com> wrote:

> On Mon, Aug 05, 2013 at 11:46:03AM +0200, Ingo Molnar wrote:
> > Acked-by: Ingo Molnar <mingo@kernel.org>
> > 
> > I guess you'd want to carry this in the KVM tree or so - maybe in a 
> > separate branch because it changes Xen as well?
> 
> It changes KVM host and guest side, XEN and common x86 spinlock code. I 
> think it would be best to merge common x86 spinlock bits and guest side 
> KVM/XEN bits through tip tree and host KVM part will go through KVM 
> tree. If this is OK with you, Ingo, and XEN folks Raghavendra can send 
> two separate patch series one for the tip and one for KVM host side.

Sure, that's fine - if the initial series works fine in isolation as well 
(i.e. won't break anything).

Thanks,

	Ingo
