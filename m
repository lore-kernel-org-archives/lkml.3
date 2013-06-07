Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3FGBdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:33:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62172 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3FGBdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:33:24 -0400
Date: Thu, 06 Jun 2013 20:33:20 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: cover CONFIG_BINFMT_SCRIPT in init.txt
To: Andreas Mohr <andi@lisas.de>
Cc: Andreas Mohr <andi@lisas.de>, Kris Rusocki <kszysiu@braxis.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20130603202656.GA1102@rhlx01.hs-esslingen.de> (from
	andi@lisas.de on Mon Jun  3 15:26:56 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1370568800.2776.75@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 03:26:56 PM, Andreas Mohr wrote:
> Hi,
> 
> On Mon, Jun 03, 2013 at 06:16:12AM -0500, Rob Landley wrote:
> > On 05/30/2013 03:33:10 PM, Andreas Mohr wrote:
> > >It's somewhat sad to see that that file remained at only one
> > >initial commit
> > >since 2010, thus thumbs up for your help!
> > >
> > >Docs in general seem to be a wee bit too unmaintained.
> >
> > Are you volunteering?
> 
> Yeah (sort of ;) - in fact I keep piling up some doc updates locally
> and am just waiting for them to reach critical mass
> (but first I need to get some certain driver updates submitted  
> anyway).
> 
> Andreas Mohr

No one person is an expert in every file in Documentation. My big todo  
items are centered around librarian work: reorganizing the layout of  
the directory so it's not a giant heap with everybody in the world  
dumping stuff into the root directory, or weird little crevices like  
pti/ and pps/ that have their own directory with one file in it.

Unfortunately, Documentation is the greatest source of bikeshedding in  
the kernel. Even as the directory's nominal maintainer, I can't say  
"translations don't belong in there, they belong on the web" because  
Greg KH thinks they do so he'll check them in anyway. And then nobody  
maintains them because anybody who can read the english versions (and  
thus update the translations) doesn't need the translations.

There's functional stuff in there like the devicetree bindings. There's  
a Makefile that compiles stuff under Documentation, and not just the  
htmldocs but actual code. I still don't really know why...

Unfortunately, I only really get time to deal with this sort of thing  
in the downtime between contracts, and last time I had a gap the  
massive barn-door-locking after the kernel.org breakin still had my  
account disabled because I hadn't been to an in-person conference to  
get a new pgp key signed in years. (And now that I've been to a  
conference and gotten one signed, I need to sit down and write a new  
rsync replacement on top of kup because non-security people wrote a  
bespoke security wrapper for kernel.org to replace shell access, which  
means my old rsync script that updated http://kernel.org/doc needs to  
be replaced with a rube goldberg monstrosity to do the same thing in a  
much more complicated and less efficient way.)

It's on the todo list. (You may have noticed I'm a couple days behind  
on just email. Next scheduled gap's in August...)

Rob