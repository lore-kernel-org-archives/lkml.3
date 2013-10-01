Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3JAIko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab3JAIkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:40:25 -0400
Date: Tue, 1 Oct 2013 11:39:08 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, agraf@suse.de, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131001083908.GA17294@redhat.com>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
 <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
 <5243F933.7000907@redhat.com>
 <20131001083426.GB27484@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001083426.GB27484@concordia>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 06:34:26PM +1000, Michael Ellerman wrote:
> On Thu, Sep 26, 2013 at 11:06:59AM +0200, Paolo Bonzini wrote:
> > Il 26/09/2013 08:31, Michael Ellerman ha scritto:
> > > Some powernv systems include a hwrng. Guests can access it via the
> > > H_RANDOM hcall.
> > 
> > Is there any reason to do this in the kernel?  
> 
> It's less code, and it's faster :)
> 
> > It does not have to be a particularly fast path;
> 
> Sure, but do we have to make it slow on purpose?
> 
We do not put non performance critical devices into the kernel.

--
			Gleb.
