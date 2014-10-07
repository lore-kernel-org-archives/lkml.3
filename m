Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaJGKpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:45:09 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:43601 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJGKpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:45:05 -0400
Date: Tue, 7 Oct 2014 11:44:47 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Andreas Mohr <andi@lisas.de>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] Workable vintage driver support mechanism? (Re:
 [PATCH v3] ES938 support for ES18xx driver)
Message-ID: <20141007114447.35379ef7@alan.etchedpixels.co.uk>
In-Reply-To: <5432F060.5060307@ladisch.de>
References: <1412027079-15876-1-git-send-email-linux@rainbow-software.org>
	<s5h7g0dzgd5.wl-tiwai@suse.de>
	<201410061555.19007.linux@rainbow-software.org>
	<s5ha959xp53.wl-tiwai@suse.de>
	<20141006184150.GA2465@rhlx01.hs-esslingen.de>
	<5432F060.5060307@ladisch.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Oct 2014 21:41:20 +0200
Clemens Ladisch <clemens@ladisch.de> wrote:

> Andreas Mohr wrote:
> > I think I have an idea which might be useful to accept:
> > for every piece of sufficiently "vintage" submission,
> > people would be tasked with offering (or somehow ensuring)
> > a sufficiently closely time-related cleanup in other places.
> 
> The problem that such a new driver imposes is not a one-time reduction
> in overall kernel quality, but the ongoing maintenance effort.

Vintage is not IMHO a useful test. We have plenty of vintage hardware
with active hands-on maintainers which causes no problem, and plenty of
modern drivers with basically no maintainer that causes endless problems.

I think there is much merit in the Debian approach - if it's not got a
maintainer, and nobody is willing to take it on, throw it out. If it's
got a maintainer leave it in.

Economics will resolve the rest of the problem reasonably efficiently. If
someone cares enough about using it then they'll figure out how to keep
it maintained.

Alan
