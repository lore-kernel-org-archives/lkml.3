Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3LGDbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 22:31:09 -0500
Received: from muin.pair.com ([209.68.1.55]:53209 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab3LGDbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 22:31:07 -0500
MIME-Version: 1.0
In-Reply-To: <529CEA30.8010805@infradead.org>
References: <529CEA30.8010805@infradead.org>
Date: Fri, 6 Dec 2013 21:31:05 -0600
Message-ID: <CAOZdJXWukOZt9KCjph3wWPkt5NO166syL1BKS6CZHExxc=edGA@mail.gmail.com>
Subject: Re: [PATCH] init.h: add missing initcall variants
From: Timur Tabi <timur@tabi.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 2:14 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Add missing initcall variants when building for loadable modules.
> This fixes this build error on powerpc allmodconfig:
>
> drivers/tty/ehv_bytechan.c: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]

Acked-by: Timur Tabi <timur@tabi.org>

However, I wonder if it makes sense to have a console_initcall in a
module at all.  Is it possible to load and use a console driver as a
module?
