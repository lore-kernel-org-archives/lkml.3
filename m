Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab3BTJPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:15:06 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53490 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3BTJPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:15:01 -0500
Date: Wed, 20 Feb 2013 10:14:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/platform changes for v3.9
Message-ID: <20130220091457.GA2252@gmail.com>
References: <20130219154128.GA15608@gmail.com>
 <CA+55aFxn=xFGhF8L2pJYP8wOe3VdCpGtaibB0bbRuH8FAKkCNg@mail.gmail.com>
 <20130220090238.GA18213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220090238.GA18213@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > My main desktop just had a reboot failure - it just got 
> > stuck at the end, not powering down, and not rebooting like 
> > it should have.

if it matters: I have test machines of various x86 vintage, most 
of which test booted these trees before sending, and none had 
reboot failures: so I'd suspect the hang is either system/driver 
specific, or somehow .config dependent. I'd be surprised if it 
was a generic hang.

Thanks,

	Ingo
