Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3HEOHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:07:09 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56361 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3HEOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:07:07 -0400
Date: Mon, 5 Aug 2013 10:05:38 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Gleb Natapov <gleb@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, mingo@redhat.com,
        x86@kernel.org, tglx@linutronix.de, jeremy@goop.org,
        konrad wilk <konrad.wilk@oracle.com>, hpa@zytor.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com,
        stefano stabellini <stefano.stabellini@eu.citrix.com>,
        andi@firstfloor.org, attilio rao <attilio.rao@citrix.com>,
        ouyang@cs.pitt.edu, gregkh@suse.de, agraf@suse.de,
        chegu vinod <chegu_vinod@hp.com>, torvalds@linux-foundation.org,
        avi kivity <avi.kivity@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa vaddagiri <srivatsa.vaddagiri@gmail.com>
Message-ID: <1952910281.9619371.1375711538505.JavaMail.root@redhat.com>
In-Reply-To: <20130805135222.GA32429@gmail.com>
References: <51F0ED31.3040200@linux.vnet.ibm.com> <20130731062440.GK28372@redhat.com> <51FA1087.9080908@linux.vnet.ibm.com> <20130802092539.GB28327@gmail.com> <20130802095406.GB30072@redhat.com> <20130805094603.GA29303@gmail.com> <20130805095901.GL2258@redhat.com> <20130805135222.GA32429@gmail.com>
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - SAF5 (Mac)/8.0.3_GA_5664)
Thread-Topic: kvm : Paravirtual ticketlocks support for linux guests running on KVM hypervisor
Thread-Index: jx6DpRQSa4xLQHdtHrU9Qag3/Sbj0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Mon, Aug 05, 2013 at 11:46:03AM +0200, Ingo Molnar wrote:
> > > Acked-by: Ingo Molnar <mingo@kernel.org>
> > > 
> > > I guess you'd want to carry this in the KVM tree or so - maybe in a
> > > separate branch because it changes Xen as well?
> > 
> > It changes KVM host and guest side, XEN and common x86 spinlock code. I
> > think it would be best to merge common x86 spinlock bits and guest side
> > KVM/XEN bits through tip tree and host KVM part will go through KVM
> > tree. If this is OK with you, Ingo, and XEN folks Raghavendra can send
> > two separate patch series one for the tip and one for KVM host side.
> 
> Sure, that's fine - if the initial series works fine in isolation as well
> (i.e. won't break anything).

It would be a big problem if it didn't!  Raghavendra, please send the
two separate series as Gleb explained above.

Thanks,

Paolo
