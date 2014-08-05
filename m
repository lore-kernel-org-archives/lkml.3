Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaHEWXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:23:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:46161 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaHEWXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:23:11 -0400
Date: Tue, 5 Aug 2014 18:23:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Torsten Duwe <duwe@lst.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] hwrng: Pass entropy to add_hwgenerator_randomness() in
 bits, not bytes
Message-ID: <20140805222303.GB26399@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Torsten Duwe <duwe@lst.de>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"H . Peter Anvin" <hpa@zytor.com>
References: <1406326758-4516-1-git-send-email-sboyd@codeaurora.org>
 <20140728094929.GJ972@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728094929.GJ972@lst.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:49:29AM +0200, Torsten Duwe wrote:
> On Fri, Jul 25, 2014 at 03:19:18PM -0700, Stephen Boyd wrote:
> > rng_get_data() returns the number of bytes read from the hardware.
> > The entropy argument to add_hwgenerator_randomness() is passed
> > directly to credit_entropy_bits() so we should be passing the
> > number of bits, not bytes here.
> 
> Absolutely correct.
> 
> Acked-by: Torsten Duwe <duwe@suse.de>

Applied, thanks.

					- Ted
