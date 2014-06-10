Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaFJUuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:50:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaFJUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:50:53 -0400
Date: Tue, 10 Jun 2014 13:50:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de, hpa@linux.intel.com
Cc: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/vdso] x86, vdso: Use <tools/le_byteshift.h> for
 littleendian access
Message-Id: <20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org>
In-Reply-To: <tip-bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7@git.kernel.org>
References: <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
	<tip-bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7@git.kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 15:00:29 -0700 "tip-bot for H. Peter Anvin" <tipbot@zytor.com> wrote:

> Commit-ID:  bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7
> Gitweb:     http://git.kernel.org/tip/bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Fri, 6 Jun 2014 14:30:37 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 6 Jun 2014 14:54:54 -0700
> 
> x86, vdso: Use <tools/le_byteshift.h> for littleendian access

Getting closer.

In file included from arch/x86/vdso/vdso2c.c:80:
arch/x86/vdso/vdso2c.h: In function 'go64':
arch/x86/vdso/vdso2c.h:119: warning: implicit declaration of function 'htole16'
/tmp/cc04m2KE.o: In function `go':
vdso2c.c:(.text+0xf69): undefined reference to `htole16'
vdso2c.c:(.text+0x12e6): undefined reference to `htole16'
