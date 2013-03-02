Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3CBKGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 05:06:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55710 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3CBKGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 05:06:12 -0500
Date: Sat, 2 Mar 2013 02:05:41 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mark Fasheh <mfasheh@suse.de>, Richard Weinberger <richard@nod.at>,
        ocfs2-devel@oss.oracle.com, ocfs2-user@oss.oracle.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@sigma-star.at
Subject: Re: OCFS2 mainline state?
Message-ID: <20130302100540.GB22177@localhost>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	Mark Fasheh <mfasheh@suse.de>, Richard Weinberger <richard@nod.at>,
	ocfs2-devel@oss.oracle.com, ocfs2-user@oss.oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@sigma-star.at
References: <512BCA9E.4090702@nod.at>
 <20130225211103.GA13510@wotan.suse.de>
 <20130225211617.GF4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225211617.GF4503@ZenIV.linux.org.uk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 09:16:18PM +0000, Al Viro wrote:
> On Mon, Feb 25, 2013 at 01:11:03PM -0800, Mark Fasheh wrote:
> 
> > I've seen that patch actually and yes it should have been in mainline
> > already. I didn't see whether it's in -mm (Andrew is pickup up some of the
> > patches for us right now).
> > 
> > I'll check and if it's not I'll try to send him a version of it today.
> 
> Normally filesystem trees are fed to Linus...  Or I can pick that patch via
> VFS tree (and send it to Linus tomorrow).  There also had been Jan's ocfs2
> patch a while ago; I picked only the VFS part of that series, ext* and
> IIRC xfs ones went to corresponding filesystem trees.  Should I just pick
> the ocfs2 stuff from now on?

Andrew's been picking it up.  I'm doing the Acked-by thing, until I have
a test environment back.  Thank you for offering, and if Andrew gets
tired of it before I'm fully operational, we'll happily take you up on
this.

Joel


-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

			http://www.jlbec.org/
			jlbec@evilplan.org
