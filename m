Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3JBWQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 18:16:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:36471 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3JBWQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 18:16:27 -0400
Message-ID: <1380752155.645.73.camel@pasglop>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, Alexander Graf <agraf@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Date: Thu, 03 Oct 2013 08:15:55 +1000
In-Reply-To: <20131002141032.GI17294@redhat.com>
References: <20131001083908.GA17294@redhat.com>
	 <1380620338.645.22.camel@pasglop> <524AAFAA.3010801@redhat.com>
	 <20131002050940.GA25363@drongo> <524BDD73.3020106@redhat.com>
	 <1380704789.645.57.camel@pasglop>
	 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
	 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
	 <20131002100224.GF17294@redhat.com> <1380722275.12149.28.camel@concordia>
	 <20131002141032.GI17294@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 17:10 +0300, Gleb Natapov wrote:
> > The hwrng is accessible by host userspace via /dev/mem.
> > 
> Regular user has no access to /dev/mem, but he can start kvm guest and
> gain access to the device.

Seriously. You guys are really trying hard to make our life hell or
what ? That discussion about access permissions makes no sense
whatsoever. Please stop.

Ben.


