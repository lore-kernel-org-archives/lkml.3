Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab3BYV2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:28:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab3BYV22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:28:28 -0500
Date: Mon, 25 Feb 2013 13:28:27 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, ocfs2-devel@oss.oracle.com,
        ocfs2-user@oss.oracle.com, linux-kernel@vger.kernel.org,
        jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, david@sigma-star.at
Subject: Re: OCFS2 mainline state?
Message-ID: <20130225212827.GC13510@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <512BCA9E.4090702@nod.at> <20130225211103.GA13510@wotan.suse.de> <20130225211617.GF4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225211617.GF4503@ZenIV.linux.org.uk>
Organization: SUSE Labs
User-Agent: Mutt/1.5.17 (2007-11-01)
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

I personally would absolutely be fine (and grateful) with you picking up the
Ocfs2 stuff.
	--Mark
