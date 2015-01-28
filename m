Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbbA1BEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:04:39 -0500
Received: from ozlabs.org ([103.22.144.67]:56538 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbbA1BEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:04:37 -0500
Message-ID: <1422407074.32234.2.camel@ellerman.id.au>
Subject: Re: [PATCH 0/4] defconfigs: cleanup obsolete MTD configs
From: Michael Ellerman <mpe@ellerman.id.au>
To: semen.protsenko@globallogic.com
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-mips@linux-mips.org,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-mtd@lists.infradead.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Date: Wed, 28 Jan 2015 12:04:34 +1100
In-Reply-To: <CAJOTznWHpRh8ysVxwSWyvZL1UAe-G9A64j=M6z0+zPeoycgkDg@mail.gmail.com>
References: <1422117213-3130-1-git-send-email-semen.protsenko@globallogic.com>
	 <1422118156.27947.7.camel@x220>
	 <CAJOTznWHpRh8ysVxwSWyvZL1UAe-G9A64j=M6z0+zPeoycgkDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-24 at 22:54 +0200, Sam Protsenko wrote:
> > That's news for me. I thought they are silently ignored. Do you have an
> > example of such a warning?
> 
> Not really. It was just assumption. It seems you are right, they are just
> ignored silently. But item 2 is still relevant and it was actually confused
> me when I tried to figure out MTD configuration for my platform.
> Anyway, garbage should be taken out from time to time.

The usual way that this gets dealt with is that arch maintainers (ir)regularly
run make savedefconfig on all their defconfigs.

As it happens we've done that on powerpc just recently, if you rebase onto next
you should see that, so you can drop the powerpc hunks from your patches. 

cheers


