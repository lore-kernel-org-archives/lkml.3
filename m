Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578Ab3ECXKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:10:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab3ECXK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:10:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1367612438-26490-1-git-send-email-geert@linux-m68k.org>
References: <1367612438-26490-1-git-send-email-geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        David Huggins-Daines <dhd@debian.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nubus: Kill nubus_proc_detach_device()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 04 May 2013 00:10:16 +0100
Message-ID: <24064.1367622616@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Commit 59d8053f1e16904d54ed7469d4b36801ea6b8f2c ("proc: Move non-public
> stuff from linux/proc_fs.h to fs/proc/internal.h") broke Apple NuBus
> support:
> 
> drivers/nubus/proc.c: In function ‘nubus_proc_detach_device’:
> drivers/nubus/proc.c:156: error: dereferencing pointer to incomplete type
> drivers/nubus/proc.c:158: error: dereferencing pointer to incomplete type
> 
> Fortunately nubus_proc_detach_device() is unused, and appears to have never
> been used, so just remove it.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Fine by me.

Acked-by: David Howells <dhowells@redhat.com>
