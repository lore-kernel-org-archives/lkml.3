Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab3EHSTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:19:46 -0400
Received: from lake.fysh.org ([81.94.195.195]:46903 "EHLO lake.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848Ab3EHSTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:19:45 -0400
Date: Wed, 8 May 2013 19:19:43 +0100
From: Athanasius <link@miggy.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9.1
Message-ID: <20130508181943.GC4169@fysh.org>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20130508041010.GA17374@kroah.com>
 <20130508072245.GB4169@fysh.org>
 <20130508175020.GA17950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508175020.GA17950@kroah.com>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 10:50:20AM -0700, Greg KH wrote:
> On Wed, May 08, 2013 at 08:22:45AM +0100, Athanasius wrote:
> > On Tue, May 07, 2013 at 09:10:10PM -0700, Greg KH wrote:
> > > I'm announcing the release of the 3.9.1 kernel.
> > > 
> > > All users of the 3.9 kernel series must upgrade.
> > > 
> > > The updated 3.9.y git tree can be found at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> > 
> >   Usually I can:
> > 
> > 	git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master
> 
> If you do that, you only get the master branch updated locally.  Which
> tracks Linus's tree, not the different stable releases.
> 
> > which means not having to update scripts/commandline history on each
> > major verison change, but this time I did indeed need to:
> > 
> > 	git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> > 
> > is this an intended change, or did you do something like forgetting to
> > merge into master on linux-stable ?
> 
> No, I have not changed anything on my end, perhaps you never really were
> updating the different stable branches?

  'uname -r' says I was.  Also 'git log' for my v3.8 branch currently on
3.8.9 via the 'master' method does include at least the top few commits
listed on:

<https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?id=refs/tags/v3.8.9>

Of course only having gotten to 3.8.9 a pull against linux-3.8.y does
see changes.  Perhaps someone else, or a script on git.kernel.org was
merging into master before and now isn't ?

  Anyway, if it's unsupported to pull from linux-stable.git master I'll
change my scripts.

-- 
- Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME
