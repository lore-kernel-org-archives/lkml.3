Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161855Ab3DEOGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:06:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161475Ab3DEOGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:06:52 -0400
Date: Fri, 5 Apr 2013 16:06:50 +0200
From: Jan Kara <jack@suse.cz>
To: Shea Levy <shea@shealevy.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] vfs: Report a mount r/o if the superblock is
Message-ID: <20130405140650.GA21852@quack.suse.cz>
References: <1363277360-1947-1-git-send-email-shea@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363277360-1947-1-git-send-email-shea@shealevy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-03-13 12:09:18, Shea Levy wrote:
> By calling mount(2) with MS_REMOUNT | MS_BIND on a non-bind readonly
> mountpoint, it is possible to have a readonly mount without MNT_READONLY
> in its mnt_flags. Currently, /proc/<pid>/mountinfo and statfs will
> report such a mount as r/w, even though for all intents and purposes it
> is still readonly.
> 
> This patchset fixes show_mountinfo and statfs to report such mounts as
> readonly.
  Andrew, I think the two patches in this thread deserve to be picked up...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
