Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3JCHXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:23:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:38671 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab3JCHXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:23:45 -0400
Message-ID: <1380784979.645.87.camel@pasglop>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Date: Thu, 03 Oct 2013 17:22:59 +1000
In-Reply-To: <20131003054355.GT17294@redhat.com>
References: <20131001083908.GA17294@redhat.com>
	 <1380620338.645.22.camel@pasglop> <524AAFAA.3010801@redhat.com>
	 <20131002050940.GA25363@drongo> <524BDD73.3020106@redhat.com>
	 <1380704789.645.57.camel@pasglop>
	 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
	 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
	 <20131002100224.GF17294@redhat.com> <1380751340.645.68.camel@pasglop>
	 <20131003054355.GT17294@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 08:43 +0300, Gleb Natapov wrote:
> Why it can be a bad idea? User can drain hwrng continuously making other
> users of it much slower, or even worse, making them fall back to another
> much less reliable, source of entropy.

Not in a very significant way, we generate entropy at 1Mhz after all, which
is pretty good.

Cheers,
Ben.


