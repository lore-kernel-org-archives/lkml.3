Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3IRAQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:16:03 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39071 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IRAQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:16:01 -0400
Message-ID: <1379463821.32763.601.camel@haakon3.risingtidesystems.com>
Subject: Re: linux-next stats (Was: Linux 3.12-rc1)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Sep 2013 17:23:41 -0700
In-Reply-To: <20130917155057.2125aa5f69fb9cf9bbe01166@canb.auug.org.au>
References: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
	 <20130917155057.2125aa5f69fb9cf9bbe01166@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 2013-09-17 at 15:50 +1000, Stephen Rothwell wrote:
> On Mon, 16 Sep 2013 18:08:11 -0400 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > So it's been two weeks, and the merge window for 3.12 is now closed.
> 
> As usual, the executive friendly graph is at
> http://neuling.org/linux-next-size.html :-)
> 
> (No merge commits counted, next-20130903 was the linux-next based on v3.11)
> 
> Commits in v3.12-rc1 (relative to v3.11): 9474		(v3.11-rc11:	9494)
> Commits in next-20130903:		  8891		(next-20130701:	8929)
> Commits with the same SHA1:		  7991		(		7670)
> Commits with the same patch_id:		   472	(1)	(		 759)
> Commits with the same subject line:	    70	(1)	(		  55)
> 
> (1) not counting those in the lines above.
> 
> So commits in -rc1 that were "in" next-20130903:	8533	90.1%	(8484	89.4%)
> Commits in -rc1 that were not in next-20120722:		 941	 9.9%	(1010	10.6%
> 
> So better than last time, but it would be still nice to figure out where
> the last lot came from.  I have the "git log --oneline --no-walk" list if
> someone wants them.
> 
> Some breakdown of that list:
> 
> Top ten first word of commit summary:
> 
>      57 net
>      53 mips
>      49 drm
>      47 [scsi]
>      23 perf
>      23 nfs
>      20 cifs
>      19 nvme
>      18 vfs
>      17 arm
> 
> Top ten authors:
> 
>      33 Al Viro <viro@zeniv.linux.org.uk>
>      21 Sachin Kamat <sachin.kamat@linaro.org>
>      20 Linus Torvalds <torvalds@linux-foundation.org>
>      18 James Smart <james.smart@emulex.com>
>      17 Jon Mason <jon.mason@intel.com>
>      17 Chuck Lever <chuck.lever@oracle.com>
>      16 Tomasz Figa <t.figa@samsung.com>
>      16 Jingoo Han <jg1.han@samsung.com>
>      15 Daniel Borkmann <dborkman@redhat.com>
>      14 Trond Myklebust <Trond.Myklebust@netapp.com>
> 

I'm totally confused by these stats..

The target-pending/for-next pull had ~30 commits with the term 'target'
in the first word of the commit summary, and yours truly had 40 commits
merged.

Is there a reason why these would not be showing up in the above..?

--nab

