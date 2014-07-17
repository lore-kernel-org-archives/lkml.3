Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaGQWSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:18:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:44169 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaGQWSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:18:35 -0400
Date: Fri, 18 Jul 2014 00:17:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Krause <xerofoify@gmail.com>
cc: Richard Henderson <rth@twiddle.net>, ink@jurassic.park.msu.ru,
        Matt Turner <mattst88@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Alpha Checkpatch Errors
In-Reply-To: <CAPDOMVgJx4NTSDXyS4k9jfWzSw_vJ=TFDBPdCUgxa-Xato1bYA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1407180013260.24854@nanos>
References: <CAPDOMVgJx4NTSDXyS4k9jfWzSw_vJ=TFDBPdCUgxa-Xato1bYA@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Nick Krause wrote:

> Hey Richard and other Maintainers,
> I am wondering about cleaning up the cleanpatch errors for alpha,  as
> I  am hitting a lot of in the arch/alpha directory.
> It would be nice if I got a list of files that still need coding style
> cleanup as this may be of nice to cleanup :).

Nick, can you please stop that nonsense? checkpatch.pl is a tool to
check PATCHES and not to apply random nonsense on existing code. See
also:

  https://lwn.net/Articles/605597/

Joe, can you please finally remove the -f option from checkpatch.pl ?

Thanks,

	tglx
