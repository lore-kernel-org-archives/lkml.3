Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbaJaK2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:28:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52721 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbaJaK2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:28:05 -0400
Date: Fri, 31 Oct 2014 10:28:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH fixed] vfs: make first argument of dir_context.actor typed
Message-ID: <20141031102755.GH7996@ZenIV.linux.org.uk>
References: <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com>
 <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
 <5760.1414680426@warthog.procyon.org.uk>
 <20141030163734.GE3021@tucsk.piliscsaba.szeredi.hu>
 <20141031094639.GF3021@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031094639.GF3021@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:46:39AM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Reported-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> Here's one that actually compiles...  My only excuse for last night's one is the
> general chaos after my 2 year old drank an unknown amount of rum (he's all
> right, apparently he had the sense to refrain from excessive alcohol abuse).

Already fixed - see commit ae529b3 in vfs.git (tip of vfs.git#for-next).
