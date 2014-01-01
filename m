Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaAAMzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 07:55:46 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53340 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753588AbaAAMzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 07:55:44 -0500
Date: Wed, 1 Jan 2014 12:46:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Gerhard Sittig <gsi@denx.de>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
Message-ID: <20140101124625.GF16456@n2100.arm.linux.org.uk>
References: <m3d2kduwd7.fsf@t19.piap.pl> <20131231134820.GS8064@book.gsilab.sittig.org> <52C3066E.1070909@infradead.org> <20140101123746.GB20094@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140101123746.GB20094@book.gsilab.sittig.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 01:37:46PM +0100, Gerhard Sittig wrote:
> Last time I checked (few days ago, 'git grep -w Fixes:') it
> wasn't, at least not within the kernel source tree and its
> Documentation hierarchy.  Today's master still does not have it.
> 
> But a quick search in recent LAKML messages reveals that it's
> been in use by e.g. Olof Johansson, Jason Cooper, Rusty Russell,
> Dan Carpenter, Russell King, Mark Brown, Stephen Warren, Paul
> Walmsley, and I'm not making this up but am just referring to
> what repeatedly was requested in the past.  The form used there
> was "Fixes: <hash> (<oneline>)" though.  A doc update may be due
> to have a canonical format.

It was discussed at kernel summit, and I believe the resulting format
was only published in one of the kernel summit mailing lists.  The
outcome of it as I understand was that the format is:

Fixes: <hash> ("<one line summary>")

Though the addition of the quotes was (iirc) only something added after
the vocal discussion.  If you mail Linus a patch with a fixes line which
doesn't match that, Linus will probably fix it up... (Linus has done that
with one of mine in the past.)
