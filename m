Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaI2Sc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:32:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53250 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaI2ScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:32:25 -0400
Date: Mon, 29 Sep 2014 19:32:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND v3 PATCH 3/3] vfs: make mounts and mountstats honor root
 dir like mountinfo does
Message-ID: <20140929183222.GJ7996@ZenIV.linux.org.uk>
References: <20140929180523.GC15829@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929180523.GC15829@altlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:05:23PM +0400, Dmitry V. Levin wrote:
> Date: Wed, 17 Oct 2012 20:29:55 +0400
> 
> Change show_vfsmnt() and show_vfsstat() to show mountpoints relative
> to the root directory and skip mountpoints outside of chroot jail
> the same way as show_mountinfo() does.

Sigh...  Repeat after me:  We  Do  Not  Break  Userland.  Care to explain
why that change won't do just that?
