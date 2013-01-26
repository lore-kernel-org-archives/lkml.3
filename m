Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3AZAO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:14:27 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:47286 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3AZAOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:14:25 -0500
Date: Fri, 25 Jan 2013 16:14:19 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: paul.szabo@sydney.edu.au
Cc: 695182@bugs.debian.org, ben@decadent.org.uk, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, minchan@kernel.org
Subject: Re: [PATCH] Subtract min_free_kbytes from dirtyable memory
Message-ID: <20130126001419.GG3341@elie.Belkin>
References: <1359118913.3146.3.camel@deadeye.wl.decadent.org.uk>
 <201301252349.r0PNnFYF024399@como.maths.usyd.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301252349.r0PNnFYF024399@como.maths.usyd.edu.au>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

paul.szabo@sydney.edu.au wrote:
> Dear Ben,

>> If you can identify where it was fixed then ...
>
> Sorry I cannot do that. I have no idea where kernel changelogs are kept.

Here are some tools.

  # prerequisite:
  apt-get install git; # as root

  # to get the kernel history:
  git clone \
    https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux.git
  cd linux

  # to view the changelog:
  git log v3.2..

  # to grep change descriptions:
  git log --grep=min_free_kbytes v3.2..

  # to view the patches corresponding to changes:
  git log --patch v3.2.. -- mm/

  # graphical interface
  apt-get install gitk; # as root
  gitk v3.2.. -- mm

  # web interface:
  w3m http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git

The "exploring git history" section of the git user manual has more
details:

  http://git-htmldocs.googlecode.com/git/user-manual.html#exploring-git-history

Thanks,
Jonathan
