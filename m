Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaGNWOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:14:36 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:54107 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbaGNWOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:14:33 -0400
Date: Tue, 15 Jul 2014 00:14:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 0/38] clean-up uapi + asm-generic Kbuild files
Message-ID: <20140714221414.GA957@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <8199537.GiECsdyhzt@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8199537.GiECsdyhzt@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 05:34:59PM +0200, Arnd Bergmann wrote:
> On Monday 14 July 2014 17:06:09 Sam Ravnborg wrote:
> > 
> > What tree is the best for this stuff?
> > I would suggest to go via the asm-generic tree that Arnd has.
> > But it also touches a lot of architectures so Andrews -mm or
> > kbuild#misc could be used.
> 
> I rarely have anything to send for the asm-generic tree, usually I
> rely on things getting merged the other way round, through whoever
> has an interest in changing asm-generic.
OK - I will try to channel it through another tree.

If you could fine time to review "[PATCH 38/38] asm-generic: introduc Kbuild.generic"
I would be happy.
The patch itself is simple - but it is more if it really
is relevant. I am not sure how many files from asm-generic that
in reality end up being used by all architectures.

A possibility is to extend this so we can drop a specific file
from a few architectures could be added.
We could for example use this to add preempt.h for all architectures
except x86 that provide a x86 specific version.
But I decided to start simple.

Btw. I should have made this patch separate from the rest.
I just added it on top of the others since it touched the same area.
I will keep it separate in future submissions.

	Sam
