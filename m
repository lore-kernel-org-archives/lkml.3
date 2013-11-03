Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3KCTy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 14:54:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43233 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3KCTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 14:54:56 -0500
Date: Sun, 3 Nov 2013 19:54:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bruce Fields <bfields@fieldses.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] fixes for 3.12-final
Message-ID: <20131103195452.GL13318@ZenIV.linux.org.uk>
References: <20131103015803.GK13318@ZenIV.linux.org.uk>
 <CA+55aFy3tAeLYL3_+PbeD15p6PGS-P7bs8fMUaRVSC0OCzvq6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy3tAeLYL3_+PbeD15p6PGS-P7bs8fMUaRVSC0OCzvq6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 10:25:32AM -0800, Linus Torvalds wrote:
> Ugh.
> 
> This is too late since I want to do 3.12 today, and it seems to not be
> a regression - from what I can tell, the problem has always existed,
> no?
> 
> So I'll consider this post-3.12. However, it also strikes me that we
> should just clean things up, and make "i_ino" be an u64, and be able
> to do this without the vfs_getattr_nosec() games.

IIRC, at some point such an attempt has seriously hurt iget() on 32bit
boxen, so we ended up deciding not to go there.  Had been years ago,
though...
