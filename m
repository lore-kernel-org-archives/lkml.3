Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaALSFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:05:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34578 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaALSFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:05:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 12 Jan 2014 19:04:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Rob Landley <rob@landley.net>, Lubomir Rintel <lkundrak@v3.sk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Bernhard Kaindl <bk@suse.de>, linux1394-devel@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] docs: Update FireWire debugging documentation
Message-ID: <20140112190445.7a7ad792@stein>
In-Reply-To: <20131223161819.20613590@stein>
References: <1387708301-12048-1-git-send-email-lkundrak@v3.sk>
	<20131223161819.20613590@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 23 Stefan Richter wrote:
> CC'ing linux1394-devel, quoting in full.

(forgot to Cc akpm, who pointed me to the patch in the first place.)

> On Dec 22 Lubomir Rintel wrote:
> > The old firewire stack is long dead now and a new version firescope has been
> > released with support for current kernels.
> > 
> > Cc: Rob Landley <rob@landley.net>
> > Cc: Justin P. Mattock <justinmattock@gmail.com>
> > Cc: Bernhard Kaindl <bk@suse.de>
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> 
> Reviewed-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> > ---
> >  Documentation/debugging-via-ohci1394.txt   | 24 +++++++++---------------
> >  Documentation/power/basic-pm-debugging.txt |  2 +-
> >  2 files changed, 10 insertions(+), 16 deletions(-)
> 
> Rob, will you be taking this or should it go into linux1394.git?
> 
> Lubomir sent another patch for linux1394.git which among else also touches
> Documentation/debugging-via-ohci1394.txt, but git's default merge strategy
> handles this overlap automatically and correctly.  I.e. this can go
> separate ways to upstream.
> (http://marc.info/?l=linux1394-devel&m=138770970409985,
> "[PATCH] ohci: Turn remote DMA support into a module parameter")

Meanwhile, Andrew put the patch into -mm.  Given that linux1394.git is a
little bit more on-topic for this, and now that I committed the mentioned
related firewire-ohci patch, I copied the Documentation patch from -mm into
linux1394.git (and Andrew will drop it automatically AFAIK).
-- 
Stefan Richter
-=====-====- ---= -==--
http://arcgraph.de/sr/
