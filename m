Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3JBOd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab3JBOdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:33:21 -0400
Message-ID: <524C2EAE.7090209@redhat.com>
Date: Wed, 02 Oct 2013 16:33:18 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Michael Ellerman <michael@ellerman.id.au>, Gleb Natapov <gleb@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
References: <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia> <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop> <524AAFAA.3010801@redhat.com> <20131002050940.GA25363@drongo> <524BDD73.3020106@redhat.com> <1380704789.645.57.camel@pasglop> <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de> <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de> <20131002100224.GF17294@redhat.com> <1380722275.12149.28.camel@concordia> <029A8D6C-C23C-42B2-8C26-D76B59E2C9DD@suse.de>
In-Reply-To: <029A8D6C-C23C-42B2-8C26-D76B59E2C9DD@suse.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/10/2013 16:08, Alexander Graf ha scritto:
> > The hwrng is accessible by host userspace via /dev/mem.
> 
> A guest should live on the same permission level as a user space
> application. If you run QEMU as UID 1000 without access to /dev/mem, why
> should the guest suddenly be able to directly access a memory location
> (MMIO) it couldn't access directly through a normal user space interface.
> 
> It's basically a layering violation.

With Michael's earlier patch in this series, the hwrng is accessible by
host userspace via /dev/hwrng, no?

Paolo
