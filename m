Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaCKEGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:06:35 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:56915 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaCKEGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:06:34 -0400
MIME-Version: 1.0
Date: Tue, 11 Mar 2014 00:06:33 -0400
Message-ID: <CANx4bCB=G+ne-nbyb05EA3YPxSFqQpEy5dVNprcG2ApiCTKjWA@mail.gmail.com>
Subject: Linking reviews and commits
From: Murtuza Mukadam <murtuza.i.mukadam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Rigby <rigbypc@gmail.com>, gregkh@linuxfoundation.org,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have linked commits with their respective peer review discussion on LKML.
You can search for reviews of commits here:

http://cesel.encs.concordia.ca/process_request.php?repo=linux

We also created a tool that allows you to load and view reviews within
git (the tool is beta):

http://users.encs.concordia.ca/~m_mukada/git-review-tutorial.html

This work is done as part of my thesis.

Cheers,
Murtuza


Feedback from Greg KH and Takashi Iwai:

Greg KH found the idea of the tool useless saying, "That's what google
is for :)"

On Fri, Jan 31, 2014 at 2:03 PM, Takashi Iwai <tiwai@suse.de> wrote:
> sorry for my late response, as I've been really too busy to play with
> your shiny scripts.  Now finally I could find minutes to try out.
> Here are some comments after a short try:
> - It's nice command line things that are aligned well with the
>   existing git tools.

Thanks we tried to mirror the git commands.

> - Direct view with github isn't too bad, but a better GUI would be
>   definitely helpful, so that you can surf reviews more easily by
>   pointing a commit id.

You can search for reviews of commits here:

http://cesel.encs.concordia.ca/process_request.php?repo=linux

> - Can this work like git-notes?  That is, showing reviews via git log
>   with an option?

There is another tool that was discussed on the git mailing list that
works with git-notes:

http://repo.or.cz/w/trackgit.git

> - The installation could be a bit improved.  It's easy, but the
>   provided script works only for Debian & co.

Yes, you are right, for now the other distributions require getting
the right libraries. Is there a distribution you'd like to see in
particular?

> - A command git-review already exists (for Gerrit), so this name might
>   be confusing for some people.

Yes I we've changed the name to git-reviewed

> - I couldn't see any information, though, about how to gather the
>   reviews and put into the repo.  Is it a part of project?
>   Majority of patches are floating rather in each subsystem ML, not in
>   LKML, so each tree may need a different setup.

If you have a particular mailing list you would like us to import, we
will do it for you. If you wish to do it yourself, we have a command
git update-review

(http://users.encs.concordia.ca/~m_mukada/git-review-tutorial.html#OtherFeatures)

which will allow you to link reviews from an mbox file.
Note: since each linked email review is stored within git,
if there are a large number of reviews, it can bloat the size of your repo.
