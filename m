Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3CBOnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 09:43:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56880 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3CBOm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 09:42:59 -0500
Date: Sat, 2 Mar 2013 14:42:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat: restore timerfd_settime and timerfd_gettime
 compat
Message-ID: <20130302144256.GZ4503@ZenIV.linux.org.uk>
References: <20130302113528.GA3467@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302113528.GA3467@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 12:35:28PM +0100, Heiko Carstens wrote:
> >From 16f8402d45de11a1699ca584a6605806fe60bfc5 Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Sat, 2 Mar 2013 12:26:30 +0100
> Subject: [PATCH] compat: restore timerfd settime and gettime compat syscalls
> 
> Both compat syscalls got lost with 9d94b9e2 "switch timerfd compat syscalls
> to COMPAT_SYSCALL_DEFINE" because of a typo:
> COMPAT instead of CONFIG_COMPAT.

Applied, thanks.  I'll push fixes to Linus in about an hour...
