Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaIWO2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:28:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50850 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaIWO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:28:18 -0400
Date: Tue, 23 Sep 2014 09:28:07 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140923142807.GB19016@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 09:41:41AM -0500, Seth Forshee wrote:
> Third round of patches for making it possible to mount with fuse from
> within user namespaces. The only change since v2 is the addition of a
> patch to ensure real root is capable towards inodes whose uid/gid is
> invalid.

It's been nearly two weeks (three from the v2 patches) without any
feedback besides Serge's acks. Any other comments or objections? Anyone
planning to pick these up?

Thanks,
Seth

