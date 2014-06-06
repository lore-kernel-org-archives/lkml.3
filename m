Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaFFVAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:00:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaFFVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:00:19 -0400
Date: Fri, 6 Jun 2014 14:00:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, gorcunov@openvz.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@amacapital.net,
        mingo@kernel.org, sasha.levin@oracle.com, stefani@seibold.net,
        tglx@linutronix.de, xemul@parallels.com
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
Message-Id: <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
In-Reply-To: <201406042235.s54MZgwP020553@terminus.zytor.com>
References: <201406042235.s54MZgwP020553@terminus.zytor.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 15:35:42 -0700 "H. Peter Anvin" <hpa@linux.intel.com> wrote:

> Vdso cleanups and improvements largely from Andy Lutomirski.

arch/x86/vdso/vdso2c.h: In function 'go64':
arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le64toh'
arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le32toh'
arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le16toh'
arch/x86/vdso/vdso2c.h:119: warning: implicit declaration of function 'htole16'

My Fedora Core 6 (lol gotcha) test box doesn't have these.

http://www.unix.com/man-page/linux/3/le64toh/ has some details.  I
don't appear to have letoh64 and friends either.  

