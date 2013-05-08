Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3EHSsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:48:38 -0400
Received: from lake.fysh.org ([81.94.195.195]:47025 "EHLO lake.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab3EHSsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:48:37 -0400
Date: Wed, 8 May 2013 19:48:36 +0100
From: Athanasius <link@miggy.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9.1
Message-ID: <20130508184836.GD4169@fysh.org>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20130508041010.GA17374@kroah.com>
 <20130508072245.GB4169@fysh.org>
 <20130508175020.GA17950@kroah.com>
 <20130508181943.GC4169@fysh.org>
 <20130508182837.GA26128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508182837.GA26128@kroah.com>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 11:28:37AM -0700, Greg KH wrote:
> On Wed, May 08, 2013 at 07:19:43PM +0100, Athanasius wrote:
> >   'uname -r' says I was.  Also 'git log' for my v3.8 branch currently on
> > 3.8.9 via the 'master' method does include at least the top few commits
> > listed on:
> > 
> > <https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?id=refs/tags/v3.8.9>
> > 
> > Of course only having gotten to 3.8.9 a pull against linux-3.8.y does
> > see changes.  Perhaps someone else, or a script on git.kernel.org was
> > merging into master before and now isn't ?
> 
> No, nothing was ever mergeing into master in the linux-stable git tree.
> You might have been doing that locally, check the merges to see who was
> doing it.

  It really is just your Makefile/version commits, and then the commits
you merged in to make the release.

> >   Anyway, if it's unsupported to pull from linux-stable.git master I'll
> > change my scripts.
> 
> It's not unsupported, you will just get a copy of Linus's tree there,
> delayed by usually a -rc release or so.

  I'm going to guess that what happened then was I was lucky enough for
Linus to have released a new -rc by the time I pulled a new stable. So,
then checking out the stable tag would have pointed to the right commit
to also checkout the associated commits.
  Anyway, enough noise over this now.

-- 
- Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME
