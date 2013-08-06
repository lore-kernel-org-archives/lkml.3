Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3HFUvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:51:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3HFUvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:51:19 -0400
Date: Tue, 6 Aug 2013 13:51:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        wim@iguana.be
Subject: Re: [PATCH] lto, watchdog/hpwdt.c: Make assembler label global
Message-Id: <20130806135118.aa11129d582b8aee00accb8a@linux-foundation.org>
In-Reply-To: <1375740999-8097-1-git-send-email-andi@firstfloor.org>
References: <1375740999-8097-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Aug 2013 15:16:39 -0700 Andi Kleen <andi@firstfloor.org> wrote:

> We cannot assume that the inline assembler code always ends up
> in the same file as the original C file.

um, why not?  You put an asm(".text\n...") into a .c file and you
expect that assembly code to be emitted into the .s file then assembled
into the .o file.

Obviously something somewhere is doing something unexpected.  Much more
detail needed, please.

Also...  what's "lto"?  Link Time Optimization?  It's unclear how this
fits into that.  Please provide that additional background info in these
patches so that others know what's going on and so that others (such as
me) can help people avoid making these mistakes in the future.

