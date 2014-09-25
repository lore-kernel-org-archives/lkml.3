Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaIYKzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:55:06 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62566 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaIYKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:55:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
Date: Thu, 25 Sep 2014 12:54:49 +0200
Message-ID: <11277081.DWgcnnZv54@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ58h4VKrr-wHe6iD+aPB8QU=xLo03kW5k6QDpLW5Et0DGw@mail.gmail.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com> <3608975.MxU44B73lk@wuerfel> <CAFiDJ58h4VKrr-wHe6iD+aPB8QU=xLo03kW5k6QDpLW5Et0DGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ErImVgkE+8bRydvi64pjDyzOXh3MbkuTXyBT0WXKtEx
 4+XfxBDN8KNQSyrcwJNaQk2dlo9gaD4CY7L2WugBg5+7y+5zbd
 WU+crYrpJOTONcotTTd76/GD8mMAplxdwS9jhCFh89UsW3GJw3
 GCkdLsNrgt1hIB60gvnjit1wvgydL0izo5O8LvIyuVRMLXZsU8
 OoM7609thiEIBrDN3U6nEJ648CdHh5jgDedpPM7IWLd372krfI
 j21dy6LgJ0GdwkpCaA64z4YOXxb4BNNjGD2+naAH9QweGJcWad
 H2LjJue6GkIJnXUDkEt72YFE603AAuT766dZowAu2KevOX+KgY
 sY8chsJNJ/ROai7HnucA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014 16:33:33 Ley Foon Tan wrote:
> There are 4 patches that touching code outside of arch/nios2,
> including this patch.
> Do we have maintainers for common files for patch #15, #27 and #28
> below? Can't find this info from MAINTAINERS file.
> It is good if you can take a look this v3 patchset so I can send pull
> request if no further issue. Thanks!
> 
> [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP

You already have my Ack, which is sufficient here.

> [PATCH v3 15/29] Add ELF machine define for Nios2

I'm not maintaining this one, but it looks very obvious, please
add my Ack as well. I don't think you need to wait for anybody's
input here.

> [PATCH v3 27/29] MAINTAINERS: Add nios2 maintainer

This one is fine to go in. You basically own the entry though, so if
anybody wants to change the text for nios2 later, they should ask
for your Ack.

> [PATCH v3 28/29] Documentation: Add documentation for Nios2 architecture

Randy Dunlap <rdunlap@infradead.org> is the maintainer listed for
Documentation, and I see you already have linux-doc@vger.kernel.org
on Cc here. Please make sure that Randy is on Cc for the documentation
patches as well. A lot of documentation patches go in without his
Ack, which I think is fine as long as someone else (i.e. you) is
responsible for maintaining that documentation later.

	Arnd
