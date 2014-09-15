Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaIOFS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 01:18:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36344 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaIOFSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 01:18:55 -0400
Date: Mon, 15 Sep 2014 06:18:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Seunghun Lee <waydi1@gmail.com>
Cc: Bruce Fields <bfields@fieldses.org>, ink@jurassic.park.msu.ru,
        jlayton@poochiereds.net, linux-fsdevel@vger.kernel.org,
        linux-alpha@vger.kernel.org, mattst88@gmail.com, rth@twiddle.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: move getname() from callers to do_mount()
Message-ID: <20140915051850.GT7996@ZenIV.linux.org.uk>
References: <1410537212-3153-1-git-send-email-waydi1@gmail.com>
 <1410700510-15408-1-git-send-email-waydi1@gmail.com>
 <20140914181259.GQ7996@ZenIV.linux.org.uk>
 <CA+LGb9aaMpiotK7-NUv4hKcJHbuWQE=DC=p=90ZguWqn44qcTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+LGb9aaMpiotK7-NUv4hKcJHbuWQE=DC=p=90ZguWqn44qcTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 01:39:19PM +0900, Seunghun Lee wrote:
> 2014. 9. 15. 오전 3:13에 "Al Viro" <viro@zeniv.linux.org.uk> wrote:
> > Applied with one modification: this getname/kern_path/putname is

> Ok, I will resend it after modification.

See above...  It's already in vfs.git#for-next.  The last commit of the
branch at the moment.  The change was trivial - done it while applying the
patch.
