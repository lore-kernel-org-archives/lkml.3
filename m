Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3JBWNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 18:13:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:36446 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab3JBWNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 18:13:35 -0400
Message-ID: <1380751988.645.72.camel@pasglop>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Michael Ellerman <michael@ellerman.id.au>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Date: Thu, 03 Oct 2013 08:13:08 +1000
In-Reply-To: <029A8D6C-C23C-42B2-8C26-D76B59E2C9DD@suse.de>
References: <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia>
	 <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop>
	 <524AAFAA.3010801@redhat.com> <20131002050940.GA25363@drongo>
	 <524BDD73.3020106@redhat.com> <1380704789.645.57.camel@pasglop>
	 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
	 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
	 <20131002100224.GF17294@redhat.com> <1380722275.12149.28.camel@concordia>
	 <029A8D6C-C23C-42B2-8C26-D76B59E2C9DD@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 16:08 +0200, Alexander Graf wrote:
> A guest should live on the same permission level as a user space
> application. If you run QEMU as UID 1000 without access to /dev/mem,
> why should the guest suddenly be able to directly access a memory
> location (MMIO) it couldn't access directly through a normal user
> space interface.
> 
> It's basically a layering violation.

Guys, please stop with the academic non-sense !

Ben.


