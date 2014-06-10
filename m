Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaFJWGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:06:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbaFJWGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:06:02 -0400
Date: Tue, 10 Jun 2014 15:06:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, luto@amacapital.net, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        "tip-bot for H. Peter Anvin" <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/vdso] x86, vdso: Use <tools/le_byteshift.h> for
 littleendian access
Message-Id: <20140610150600.af0649ca26db602d51fe8899@linux-foundation.org>
In-Reply-To: <53977885.8010709@zytor.com>
References: <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
	<tip-bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7@git.kernel.org>
	<20140610135051.c3c34165f73d67d218b62bd9@linux-foundation.org>
	<53977885.8010709@zytor.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 14:28:37 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> Want to test this patch before I commit it?
> 
> ...
>
> >From 15ea1a528e08c6bc322f10686ec8d73ba413b941 Mon Sep 17 00:00:00 2001
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Tue, 10 Jun 2014 14:25:26 -0700
> Subject: [PATCH] x86, vdso: Remove one final use of htole16()
> 
> One final use of the macros from <endian.h> which are not available on
> older system.  In this case we had one sole case of *writing* a
> littleendian number, but the number is SHN_UNDEF which is the constant
> zero, so rather than dealing with the general case of littleendian
> puts here, just document that the constant is zero and be done with
> it.

Compiles and boots, thanks.
