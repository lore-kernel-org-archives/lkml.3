Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaHKTgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:36:15 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:58686 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaHKTgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:36:12 -0400
Date: Mon, 11 Aug 2014 21:36:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: josh@joshtriplett.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] x86: Add "make tinyconfig" to configure the
 tiniest possible kernel
Message-ID: <20140811193605.GA20482@ravnborg.org>
References: <20140807190243.GA5580@jtriplet-mobl1>
 <20140809001010.GA9437@jtriplet-mobl1>
 <CA+55aFxaY5q4XhCVgpOBP_dmn+=6JzK+PkX8OHhzZmM7g+NU2g@mail.gmail.com>
 <20140811181521.GA29208@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811181521.GA29208@cloud>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 11:15:21AM -0700, josh@joshtriplett.org wrote:
> On Fri, Aug 08, 2014 at 06:22:20PM -0700, Linus Torvalds wrote:
> > On Fri, Aug 8, 2014 at 5:10 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > > Since commit 5d2acfc7b974bbd3858b4dd3f2cdc6362dd8843a ("kconfig: make
> > > allnoconfig disable options behind EMBEDDED and EXPERT") in 3.15-rc1,
> > > "make allnoconfig" disables every possible config option.
> > 
> > May I suggest pushing these through the kbuild tree, rather than
> > (judging by the people cc'd) the x86 trees?
> 
> By all means; v3 seems sufficiently generic that it makes more sense for
> both of these patches to go in through a kbuild tree, or something else
> suitably general such as Andrew's tree.
> 
> Would someone mind picking it up, please?
I will take care that they are channeled through kbuild tree.

We are too late for this merge window so we are not in a hurry.

	Sam
