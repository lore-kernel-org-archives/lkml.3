Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaIWReD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:34:03 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:58145
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbaIWReC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:34:02 -0400
Date: Tue, 23 Sep 2014 19:08:23 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140923170822.GA15489@mail.hallyn.com>
References: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
 <20140923142807.GB19016@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923142807.GB19016@ubuntu-hedt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> On Fri, Sep 12, 2014 at 09:41:41AM -0500, Seth Forshee wrote:
> > Third round of patches for making it possible to mount with fuse from
> > within user namespaces. The only change since v2 is the addition of a
> > patch to ensure real root is capable towards inodes whose uid/gid is
> > invalid.
> 
> It's been nearly two weeks (three from the v2 patches) without any
> feedback besides Serge's acks. Any other comments or objections? Anyone
> planning to pick these up?
> 
> Thanks,
> Seth

FWIW I was able to mount ext2, ext4, and iso filesystems inside an
unprivileged container with these patches.  Thanks much!

-serge
