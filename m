Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaLIKOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:14:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:43674 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbaLIKOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:14:01 -0500
Message-ID: <1418119994.13358.43.camel@kernel.crashing.org>
Subject: Re: powerpc32: missing accessors to pgprot_t objects
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: LEROY Christophe <christophe.leroy@c-s.fr>,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Dec 2014 21:13:14 +1100
In-Reply-To: <20141209100617.630111400EA@ozlabs.org>
References: <20141209100617.630111400EA@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 21:06 +1100, Michael Ellerman wrote:
> On Mon, 2014-08-12 at 14:16:29 UTC, LEROY Christophe wrote:
> > Compilation with #define STRICT_MM_TYPECHECKS in arch/powerpc/include/asm/page.h
> > fails due to missing use of pgprot_val() when using pgprot_t objects.
> 
> Any idea when this broke? Recently, or has it gone unnoticed for a long time?

Probably a very long time...

Now the reason we didn't leave STRICT_MM_TYPECHECKS enable back in the
day is that gcc was doing a terrible job at compiling it resulting in
bloated inefficient code.

I wouldn't be surprised if that is all fixed...

Cheers,
Ben.


