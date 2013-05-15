Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3EOWDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:03:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50906 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3EOWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:03:36 -0400
Date: Wed, 15 May 2013 23:03:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: P??draig Brady <P@draigBrady.com>
Cc: linux-kernel@vger.kernel.org, Eric Blake <eblake@redhat.com>
Subject: Re: RFC: allow empty symlink targets
Message-ID: <20130515220335.GV25399@ZenIV.linux.org.uk>
References: <1358427833-3847-1-git-send-email-P@draigBrady.com>
 <50F8252C.2060404@draigBrady.com>
 <519381D8.5080206@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519381D8.5080206@draigBrady.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 01:38:48PM +0100, P??draig Brady wrote:
> >> In today's Austin Group meeting, I was tasked to open a new bug that
> >> would state specifically how the empty symlink is resolved; the intent
> >> is to allow both Solaris behavior (current directory) and BSD behavior
> >> (ENOENT).  Meanwhile, everyone was in agreement that the Linux kernel
> >> has a bug for rejecting the creation of an empty symlink, but once that
> >> bug is fixed, then Linux can choose either Solaris or BSD behavior for
> >> how to resolve such a symlink.

Austin Group Is At It Again, Demands at 11...

Would you mind explaining who's "everyone" and why would we possibly
want to honour that agreement of yours?  Functionality in question is
utterly pointless, seeing that semantics of such symlinks is OS-dependent
anyway *and* that blanket refusal to traverse such beasts is a legitimate
option.  What's the point in allowing to create them in the first place?
