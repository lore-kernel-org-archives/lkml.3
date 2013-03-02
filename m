Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3CBSfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 13:35:54 -0500
Received: from mout.gmx.net ([212.227.17.20]:56871 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3CBSfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 13:35:53 -0500
X-Authenticated: #3713698
X-Provags-ID: V01U2FsdGVkX19GW/10UilG618vhEqB026Yt9uXvPSQqSx7RkZZR/
	xGpSHCygH2sQPD
Date: Sat, 2 Mar 2013 19:35:45 +0100
From: Florian Mickler <fmickler@gmx.de>
To: Jani Nikula <jani.nikula@intel.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: A patch referencing this bug report has been merged...
Message-ID: <20130302193545.44b68282@schatten.dmk.lab>
In-Reply-To: <87zjzrdodi.fsf@intel.com>
References: <87zjzrdodi.fsf@intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 11:14:01 +0200
Jani Nikula <jani.nikula@intel.com> wrote:

> 
> Hi Florian, all -
> 
> First, thanks for your work on adding the bugzilla comments when patches
> referencing bugs get merged. I find it useful.
> 
> Recently however there was a comment about a commit referencing a commit
> referencing the bug report. Turns out the comment was missing one level
> of indirection, it was really about a commit referencing a commit
> referencing a commit referencing the bug [1].
> 
> Do we really need go that far, or is that a bug in your scripts? I think
> three levels of indirection is more noise than signal; two might be
> still be okay. What do others think?
> 
> BR,
> Jani.
> 
> 
> [1] https://bugs.freedesktop.org/show_bug.cgi?id=52424#c56

Is it really a problem? I can change it of course, but I doubt it is
worth the hassle. At the moment I just record sha1 -> bug associations
and if in a commit message, the mentioned (full!) sha1 is associated to
a bug, I associate that commit with that bug. 

If someone goes to the trouble to actually mention the sha1 in a
commit message, that probably means it really is an important
connection.
And if that commit is associated with a bug, then that should mean
something too. 

Think about multiple attempts to fix a bug which get always reverted
because the hardware is really acting up in different ways with every
attempt... 

As it is, I don't think it is worth the trouble. If you feel strongly
about the message, I can reword it to be somewhat unspecific about the
level of indirection... what do you think?


Regards,
Flo

p.s.: sorry for the late response, I'm having a bit of trouble with my
mail setup at the moment and too much to do...

 
