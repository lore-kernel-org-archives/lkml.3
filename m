Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3GQAFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:05:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:46515 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab3GQAFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:05:04 -0400
Message-ID: <1374019445.19894.403.camel@pasglop>
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Neil Horman <nhorman@tuxdriver.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
Date: Wed, 17 Jul 2013 10:04:05 +1000
In-Reply-To: <1374014420.8183.342@snotra>
References: <1374014420.8183.342@snotra>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 17:40 -0500, Scott Wood wrote:
> On 07/15/2013 03:47:06 AM, Benjamin Herrenschmidt wrote:
> > On Mon, 2013-07-15 at 14:04 +1000, Anton Blanchard wrote:
> > > Module CRCs are implemented as absolute symbols that get resolved by
> > > a linker script. We build an intermediate .o that contains an
> > > unresolved symbol for each CRC. genksysms parses this .o, calculates
> > > the CRCs and writes a linker script that "resolves" the symbols to
> > > the calc
> > 
> > Scott, can somebody from FSL test that on 32-bit and Ack it ?
> > 
> > Thanks !
> > 
> > Cheers,
> > Ben.
> 
> It boots for me on e500mc and I can insert modules.

But does perf work ? :-)

Cheers,
Ben.


