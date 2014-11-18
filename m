Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaKRKML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:12:11 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:54512 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbaKRKMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:12:08 -0500
Message-ID: <1416305525.7024.15.camel@x220>
Subject: Re: ARM: shmobile: ARCH_R8A7793?
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Date: Tue, 18 Nov 2014 11:12:05 +0100
In-Reply-To: <CAMuHMdUFZo+r-N0Ofa1d6PHDtB6dqZfChpLgOz_XtruWD3_a3g@mail.gmail.com>
References: <1416302641.7024.7.camel@x220>
	 <CAMuHMdUFZo+r-N0Ofa1d6PHDtB6dqZfChpLgOz_XtruWD3_a3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2014 10:12:05.0962 (UTC) FILETIME=[1AED92A0:01D00318]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 10:36 +0100, Geert Uytterhoeven wrote:
> On Tue, Nov 18, 2014 at 10:24 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Your commit 7a2071c58f36 ("ARM: shmobile: Add early debugging support
> > using SCIF(A)") is included in today's linux-next (ie, next-20141118).
> > It adds an (optional) dependency on the Kconfig symbol ARCH_R8A7793. But
> > that symbol isn't part of next-20141118.
> >
> > Is a patch that adds this symbol queued somewhere?
> 
> Not yet. I was just a bit pro-active ;-)

My script will stay silent (as might future, proper, bots) if you don't
add references to Kconfig symbols before adding the symbol itself.
(Whether or not it's worth it to remove this dependency here and add it
to the queue that adds this symbol is up to you, I guess.)

Unless the symbol takes a long time to land I'll try not to bother you
again.

> However, there are already references to r8a7793 in DT binding documentation,
> and in of_device_id arrays in drivers.

I see.


Paul Bolle

