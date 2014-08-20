Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaHTFKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:10:51 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:57903 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaHTFKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:10:50 -0400
Date: Wed, 20 Aug 2014 07:10:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Overriding -Werror
Message-ID: <20140820051044.GA27828@ravnborg.org>
References: <20140814222119.GD18411@ld-irv-0074>
 <87ppfwmxic.fsf@tassilo.jf.intel.com>
 <20140819201129.GA24217@ravnborg.org>
 <20140819234359.GJ4120@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819234359.GJ4120@two.firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 01:43:59AM +0200, Andi Kleen wrote:
> On Tue, Aug 19, 2014 at 10:11:30PM +0200, Sam Ravnborg wrote:
> > On Tue, Aug 19, 2014 at 06:15:07AM -0700, Andi Kleen wrote:
> > > Brian Norris <computersforpeace@gmail.com> writes:
> > > >
> > > > 4. better ideas?
> > > 
> > > Just send patches to remove -Werror in all architectures
> > > as a tree sweep (and anywhere else where someone misguided add it)
> > In arch/sparc/ we have -Werror and this has never troubled us.
> > In fact more than once people had tried to provide sloppy code that
> > failed due to -Werror so it got fixed up front.
> 
> It's a major mistake to not support future gccs for released source.
Until now this has not been an issue - for the sparc bits.

If newer gcc's turn out to give legit warnings then if someone provides
a little help (configure command-line to build gcc) the warnings will
be fixed. And that should hold true for any decent maintained piece of SW.

If the intent is to use bleeding edge gcc then -Werrror can be annoying
and the right fix would be to make it possible to diable it on the
command-line.

	Sam
