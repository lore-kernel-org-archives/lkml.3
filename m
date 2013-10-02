Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3JBV6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:58:55 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39808 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3JBV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:58:53 -0400
Message-ID: <1380751112.645.64.camel@pasglop>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Alexander Graf <agraf@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Gleb Natapov <gleb@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Date: Thu, 03 Oct 2013 07:58:32 +1000
In-Reply-To: <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
	 <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
	 <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia>
	 <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop>
	 <524AAFAA.3010801@redhat.com> <20131002050940.GA25363@drongo>
	 <524BDD73.3020106@redhat.com> <1380704789.645.57.camel@pasglop>
	 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100221-0260-0000-0000-000003B892B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 11:11 +0200, Alexander Graf wrote:

> Right, and the difference for the patch in question is really whether
> we handle in in kernel virtual mode or in QEMU, so the bulk of the
> overhead (kicking threads out of  guest context, switching MMU
> context, etc) happens either way.
> 
> So the additional overhead when handling it in QEMU here really boils
> down to the user space roundtrip (plus another random number read
> roundtrip).

Hrm, Michael had a real mode version ... not sure where it went then.

Cheers,
Ben.


