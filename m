Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbaDJTgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:36:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60584 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaDJTgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:36:43 -0400
Date: Thu, 10 Apr 2014 20:36:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH 11/15] kernel:acct:spaces required
Message-ID: <20140410193641.GE18016@ZenIV.linux.org.uk>
References: <1397156046-6837-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397156046-6837-1-git-send-email-paulmcquad@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 07:54:06PM +0100, Paul McQuade wrote:
> ERROR: spaces required around that '>' (ctx:VxV)

Egads, man...

a) ERROR (in ALL CAPS, no less) according to whom?  Sure, it's nicer to
add those spaces, but do you really think that it deserves a separate
patch, especially with such a commit message?

b) AFAICS, you've posted at least 4 such one-liners to kernel/acct.c, with
commit messages that sound like "Because The Most Holy sendpatch.pl (All Praise
sendpatch.pl) Says So".  There might be some reason to split the
asm/uaccess.h -> linux/uaccess.h replacement into a separate commit, but
the rest of that?  Come on...

Trivial whitespace, etc. changes like that should be clearly marked as such
and not split beyond reasonable...
