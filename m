Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3FHJNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 05:13:18 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49131 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3FHJNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 05:13:15 -0400
Date: Sat, 8 Jun 2013 11:13:14 +0200
From: Andreas Mohr <andi@lisas.de>
To: Rob Landley <rob@landley.net>
Cc: Andreas Mohr <andi@lisas.de>, Kris Rusocki <kszysiu@braxis.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: cover CONFIG_BINFMT_SCRIPT in init.txt
Message-ID: <20130608091314.GA5027@rhlx01.hs-esslingen.de>
References: <20130603202656.GA1102@rhlx01.hs-esslingen.de>
 <1370568800.2776.75@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370568800.2776.75@driftwood>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 08:33:20PM -0500, Rob Landley wrote:
> No one person is an expert in every file in Documentation. My big
> todo items are centered around librarian work: reorganizing the
> layout of the directory so it's not a giant heap with everybody in
> the world dumping stuff into the root directory, or weird little
> crevices like pti/ and pps/ that have their own directory with one
> file in it.

Indeed, layout in kernel could be improved somewhat.
Would be nice to find a layout that's suitably organized
and more or less tries to *match* a good future
(since it does not quite seem to exist yet) layout in Kconfig areas
(where it's increasingly difficult to find things easily
due to number of possibilities growing massively thanks to many
new drivers and not enough obvious higher-level abstraction).
Once you are asked to go beyond the third page in specific
dialog-based menuconfig sections (e.g. drivers)
you might just as well choose to enter minotaur labyrinth... :)
Of course that's needed for manual changes only (make oldconfig does the rest),
but it remains sufficiently painful.

> Unfortunately, Documentation is the greatest source of bikeshedding
> in the kernel. Even as the directory's nominal maintainer, I can't
> say "translations don't belong in there, they belong on the web"
> because Greg KH thinks they do so he'll check them in anyway. And
> then nobody maintains them because anybody who can read the english
> versions (and thus update the translations) doesn't need the
> translations.

Rock <-> hard place. :)

The question here might simply be: what's Best Practice (tm) for
dealing with translations? Unless that (I'm sure...) happens to not exist... ;)

> There's functional stuff in there like the devicetree bindings.
> There's a Makefile that compiles stuff under Documentation, and not
> just the htmldocs but actual code. I still don't really know why...

Huh? Wow.

But then a
git log -p Documentation/Makefile
easily answers it:
it's exclusively for "documentation-side" sample source files,
to ensure that they always remain correctly buildable/working samples
of source code.

> Unfortunately, I only really get time to deal with this sort of
> thing in the downtime between contracts, and last time I had a gap
> the massive barn-door-locking after the kernel.org breakin still had
> my account disabled because I hadn't been to an in-person conference
> to get a new pgp key signed in years. (And now that I've been to a
> conference and gotten one signed, I need to sit down and write a new
> rsync replacement on top of kup because non-security people wrote a
> bespoke security wrapper for kernel.org to replace shell access,
> which means my old rsync script that updated http://kernel.org/doc
> needs to be replaced with a rube goldberg monstrosity to do the same
> thing in a much more complicated and less efficient way.)

Ouch.

Count me in on the huge "people in need of sufficiently recognized pgp signing"
list, though ;)

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
