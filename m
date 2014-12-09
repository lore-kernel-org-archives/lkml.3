Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaLIKGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:06:20 -0500
Received: from ozlabs.org ([103.22.144.67]:43761 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbaLIKGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:06:18 -0500
In-Reply-To: <20141208141629.912861A5D5B@localhost.localdomain>
To: LEROY Christophe <christophe.leroy@c-s.fr>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: powerpc32: missing accessors to pgprot_t objects
Message-Id: <20141209100617.630111400EA@ozlabs.org>
Date: Tue,  9 Dec 2014 21:06:17 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-12 at 14:16:29 UTC, LEROY Christophe wrote:
> Compilation with #define STRICT_MM_TYPECHECKS in arch/powerpc/include/asm/page.h
> fails due to missing use of pgprot_val() when using pgprot_t objects.

Any idea when this broke? Recently, or has it gone unnoticed for a long time?

cheers
