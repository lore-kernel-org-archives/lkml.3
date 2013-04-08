Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714Ab3DHCAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 22:00:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59180 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934673Ab3DHCAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 22:00:18 -0400
Date: Mon, 8 Apr 2013 03:00:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make do_sysinfo() static
Message-ID: <20130408020011.GQ4068@ZenIV.linux.org.uk>
References: <20130408115325.1e4b35359271383b9c459ef9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408115325.1e4b35359271383b9c459ef9@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:53:25AM +1000, Stephen Rothwell wrote:
> The only use outside of kernel/timer.c was in kernel/compat.c, so move
> compat_sys_sysinfo() next to sys_sysinfo() in kernel/timer.c.

Please, switch it to COMPAT_SYSCALL_DEFINE, while you are at it.
