Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbaHZHhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:37:21 -0400
Received: from mail.eperm.de ([89.247.134.16]:46915 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198AbaHZHhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:37:18 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DRBG: fix bit shifting on 32 bit systems
Date: Tue, 26 Aug 2014 09:37:13 +0200
Message-ID: <1474386.ELDQfGhIun@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140826073219.GA3880@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au> <6371777.WdUEAKFPYo@myon.chronox.de> <20140826073219.GA3880@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. August 2014, 15:32:19 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Aug 26, 2014 at 09:31:02AM +0200, Stephan Mueller wrote:
> > Use ULL to mark a 64 bit value.
> > 
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> I don't think this works as size_t is still 32-bit which means
> that you'll return zero.

Oops, yes. Thank you for catching this. I guess I need __u64 for this value. A 
patch will come shortly.
> 
> Cheers,


-- 
Ciao
Stephan
