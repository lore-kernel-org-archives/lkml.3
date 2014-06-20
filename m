Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbaFTDoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 23:44:00 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:55252
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593AbaFTDn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 23:43:58 -0400
Date: Fri, 20 Jun 2014 05:43:56 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Moore <paul@paul-moore.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
Message-ID: <20140620034356.GB20601@mail.hallyn.com>
References: <20140618084046.1bce12cc@canb.auug.org.au>
 <1446656.4HCLD295vV@sifl>
 <20140620010837.692e5472@canb.auug.org.au>
 <3494783.s5KPIUO972@sifl>
 <20140620085931.6427678d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620085931.6427678d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (sfr@canb.auug.org.au):
> Hi Paul,
> 
> On Thu, 19 Jun 2014 15:47:01 -0400 Paul Moore <paul@paul-moore.com> wrote:
> >
> > I want to avoid use a -rcX release as the foundation of any of my trees; the -
> > rc releases aren't as stable and it goes against what we're trying to do with 
> > the different Linux Security trees.  Unfortunately, based on what I've read 
> > above, this seems to be incompatible with linux-next.
> 
> The problem with basing your development for v3.17 on v3.15 is that
> you  do not take into account any of the changes done by others during
> v3.16-rc1 (or even your upstream tree) some of which may be core API
> changes.
> 
> > While I hate to split my development branch from the #next branch, it seems 
> 
> I don't want that either ...
> 
> > like that is the only way to accomplish both a reasonably current and stable 
> > development tree and get the patches into linux-next.  Unless you, or anyone 
> > else for that matter, has a different suggestion I'm going to go ahead and 
> > turn the current SELinux #next branch into a development branch and create a 
> > new #next branch that will be based on the most current -rc1, this new #next 
> > branch will be created new for each major release.  Not exactly what I was 
> > hoping for, but will that work?
> 
> Do you mean that your #next branch will just be a merge of -rc1 and
> your development branch?  That would not actually change anything
> (except that you would possibly take care of some conflicts for me).
> 
> At the core, what is in linux-next should just be exactly what will be
> merged by your upstream.  My real point here is that that is not what
> has happened recently.  The patches in your tree have been
> cherry-picked or rebased into James' or Serge's trees, not merged so we
> now have duplication.  This is what you need to solve with James and
> Serge.  linux-next is a side issue - I can cope with a lot.

The duplicates were the result of several misunderstandings and general
naivity all on my part.  I'm actually still not clear on what usually
happens with the selinux tree - it feeds into linux-next, then gets
'pull'ed by James into security-next for a pull request?  Do you usually
send a request to James when ready, he pulls, then he sends pull request
to Linus?  (Or am I wrong, and you usually send your own requests to
Linus?)

-serge
