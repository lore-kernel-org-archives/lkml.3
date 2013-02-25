Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab3BYVQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:16:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58235 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab3BYVQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:16:33 -0500
Date: Mon, 25 Feb 2013 21:16:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Richard Weinberger <richard@nod.at>, ocfs2-devel@oss.oracle.com,
        ocfs2-user@oss.oracle.com, linux-kernel@vger.kernel.org,
        jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, david@sigma-star.at
Subject: Re: OCFS2 mainline state?
Message-ID: <20130225211617.GF4503@ZenIV.linux.org.uk>
References: <512BCA9E.4090702@nod.at>
 <20130225211103.GA13510@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225211103.GA13510@wotan.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 01:11:03PM -0800, Mark Fasheh wrote:

> I've seen that patch actually and yes it should have been in mainline
> already. I didn't see whether it's in -mm (Andrew is pickup up some of the
> patches for us right now).
> 
> I'll check and if it's not I'll try to send him a version of it today.

Normally filesystem trees are fed to Linus...  Or I can pick that patch via
VFS tree (and send it to Linus tomorrow).  There also had been Jan's ocfs2
patch a while ago; I picked only the VFS part of that series, ext* and
IIRC xfs ones went to corresponding filesystem trees.  Should I just pick
the ocfs2 stuff from now on?
