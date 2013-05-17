Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3EQI55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab3EQI5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:57:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87wqqy8o2k.fsf@rustcorp.com.au>
References: <87wqqy8o2k.fsf@rustcorp.com.au> <20130516164446.GA32007@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_pci: fix macro exported in uapi
Date: Fri, 17 May 2013 09:57:43 +0100
Message-ID: <32418.1368781063@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> Macro still isn't usable, because userspace can't know whether it's the
> new or old.
> 
> We need to either remove it from UAPI, or rename it to
> VIRTIO_PCI_CONFIG_OFF.

Surely, if userspace is using it as is, you can't remove it, rename it or
alter it?

David
