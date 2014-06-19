Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965675AbaFSVtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:49:53 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60407 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbaFSVtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:49:52 -0400
Date: Thu, 19 Jun 2014 17:49:49 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
cc: Stephen Boyd <sboyd@codeaurora.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Olof Johansson <olof@lixom.net>,
        Linaro Networking <linaro-networking@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: zImage: ensure header in LE format for BE8
 kernels
In-Reply-To: <7hk38cvcrm.fsf@paris.lan>
Message-ID: <alpine.LFD.2.11.1406191732590.16842@knanqh.ubzr>
References: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org> <CAGa+x85P-M3qUD6L=kezkiQ1NJymEZ9P=u2ANUZJu2b3F+o5LA@mail.gmail.com> <53A1D701.8060404@codeaurora.org> <CAGa+x86DfDjQG8gN2-x7Kapt2ipsYt879R4OK6JWGoaT93VVig@mail.gmail.com>
 <53A1D8FE.6030404@codeaurora.org> <CAGa+x87rnQntQpTkR6dZr29NvEQ4x8SOAyo+z9xuYHEdxdG1xg@mail.gmail.com> <alpine.LFD.2.11.1406181720130.16842@knanqh.ubzr> <7hk38cycuh.fsf@paris.lan> <alpine.LFD.2.11.1406191630260.16842@knanqh.ubzr>
 <7hk38cvcrm.fsf@paris.lan>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Kevin Hilman wrote:

> Nicolas Pitre <nicolas.pitre@linaro.org> writes:
> 
> > On Thu, 19 Jun 2014, Kevin Hilman wrote:
> >
> >> I think this should probably be officialized since we've taken away the
> >> ability for magic-number checking tools (like 'file') to distinguish
> >> between big- and little-endian zImages.
> >> 
> >> For now, I've updated my tools to check for 'setend be' in ARM and
> >> Thumb2 mode, but if this does get officialized, I'll gladly move over to
> >> it.
> >
> > Would you ACK this patch?
> >
> > ----- >8
> > ARM: zImage: identify kernel endianness
> >
> > With patch #8067/1 applied, it is no longer possible to determine the
> 
> minor nit: I'd rather see a commit id (commit subject) instead of the
> reference in RMK's patch tracker, but other than that...

The commit ID may not be stable, unless RMK moves it to his devel-stable 
branch.  I'll add the commit subject though.

Queued as patch #8079/1.


Nicolas
