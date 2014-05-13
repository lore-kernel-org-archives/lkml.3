Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbaEMMHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:07:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:33826 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759800AbaEMMHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:07:08 -0400
Date: Tue, 13 May 2014 14:07:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Ley Foon Tan <lftan@altera.com>, James Hogan <james.hogan@imgtec.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
In-Reply-To: <4465265.lUhYuYrZG4@wuerfel>
Message-ID: <alpine.DEB.2.02.1405131405590.6261@ionos.tec.linutronix.de>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <5371EAEB.5030100@imgtec.com> <CAFiDJ58w31gm_z3Y1Q6ZREQPW4F6uVB+vy3X1r_3kLgaEE3O1w@mail.gmail.com> <4465265.lUhYuYrZG4@wuerfel>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Arnd Bergmann wrote:
> On Tuesday 13 May 2014 18:17:40 Ley Foon Tan wrote:
> > When we export this posix_types.h file for user software, they need to
> > define this config, eg: CONFIG_32BIT_TIME to use 32 bit time. Is this
> > what we want to do?
> 
> No, this doesn't really work: You can't use CONFIG_* symbols in
> user-visible header files.

Then make the config symbol generate the header from a template.

Thanks,

	tglx
