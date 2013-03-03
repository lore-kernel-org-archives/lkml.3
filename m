Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3CCRCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 12:02:45 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49741 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3CCRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 12:02:44 -0500
Date: Sun, 3 Mar 2013 18:05:14 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Florian Mickler <fmickler@gmx.de>
Cc: Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: A patch referencing this bug report has been merged...
Message-ID: <20130303170514.GF9021@phenom.ffwll.local>
Mail-Followup-To: Florian Mickler <fmickler@gmx.de>,
	Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <87zjzrdodi.fsf@intel.com>
 <20130302193545.44b68282@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302193545.44b68282@schatten.dmk.lab>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 07:35:45PM +0100, Florian Mickler wrote:
> On Wed, 30 Jan 2013 11:14:01 +0200
> Jani Nikula <jani.nikula@intel.com> wrote:
> 
> > 
> > Hi Florian, all -
> > 
> > First, thanks for your work on adding the bugzilla comments when patches
> > referencing bugs get merged. I find it useful.
> > 
> > Recently however there was a comment about a commit referencing a commit
> > referencing the bug report. Turns out the comment was missing one level
> > of indirection, it was really about a commit referencing a commit
> > referencing a commit referencing the bug [1].
> > 
> > Do we really need go that far, or is that a bug in your scripts? I think
> > three levels of indirection is more noise than signal; two might be
> > still be okay. What do others think?
> > 
> > BR,
> > Jani.
> > 
> > 
> > [1] https://bugs.freedesktop.org/show_bug.cgi?id=52424#c56
> 
> Is it really a problem? I can change it of course, but I doubt it is
> worth the hassle. At the moment I just record sha1 -> bug associations
> and if in a commit message, the mentioned (full!) sha1 is associated to
> a bug, I associate that commit with that bug. 
> 
> If someone goes to the trouble to actually mention the sha1 in a
> commit message, that probably means it really is an important
> connection.
> And if that commit is associated with a bug, then that should mean
> something too. 
> 
> Think about multiple attempts to fix a bug which get always reverted
> because the hardware is really acting up in different ways with every
> attempt... 
> 
> As it is, I don't think it is worth the trouble. If you feel strongly
> about the message, I can reword it to be somewhat unspecific about the
> level of indirection... what do you think?

I think the multiple-indirection bug entries are ok, and could indeed be
useful to stitch together the story of a bug (or help us remember to
reopen a bug if we need to revert a patch). I guess drm/i915 hit a few
more of those than other people since we're always citing commits in full
(we paste --pretty=short into  commit messages). And we also tend to cite
a lot of commits, sometimes mentioning all relevant changes to the code in
the past few years ;-) Together with our tendecy to track all bug reports
in bugzilla that leads to the oddball useless commit entry in a bug.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
