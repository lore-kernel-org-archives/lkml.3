Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaJMVc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 17:32:29 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:47827 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaJMVc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 17:32:27 -0400
Date: Tue, 14 Oct 2014 00:32:18 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Helge Deller <deller@gmx.de>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>,
        "Carlos O'Donell" <carlos@systemhalted.org>
Subject: Re: [GIT PULL] parisc architecture patch for v3.18
Message-ID: <20141013213218.GC15738@drone.musicnaut.iki.fi>
References: <20141012100837.GA1553@p100.box>
 <20141013144143.475ca9f9@alan.etchedpixels.co.uk>
 <543C3515.9090000@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543C3515.9090000@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 13, 2014 at 10:24:53PM +0200, Helge Deller wrote:
> On 10/13/2014 03:41 PM, One Thousand Gnomes wrote:
> >I somehow doubt your kill command magically corrects its signal numbering
> >table. Likewise what does gdb do given a core dump that died from one of
> >those signals, and what does your shell report if you kill one that way.
> >It seems to me your minimal set of binaries to swap to get it right is
> >non-zero but not problematic (libc, kill, shells, top, gdb) ?
> 
> My patch of course just marks the start of a transition phase, in which
> some few applications need to be rebuilt (libc as the most important one).

Busybox handles changed signals correctly after rebuilding against
new headers. Based on quick look, GDB has never known about
PA-RISC specific numbers, so it has probably always reported some
wrong signal name...

A.
