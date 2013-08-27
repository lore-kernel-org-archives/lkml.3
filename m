Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3H0T0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:26:42 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59389 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3H0T0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:26:41 -0400
Date: Tue, 27 Aug 2013 21:26:40 +0200
From: Andreas Mohr <andi@lisas.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Mohr <andi@lisas.de>, Udo van den Heuvel <udovdh@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: weird keyboard issue (ps/2 port?) 3.9.x/3.10.x?
Message-ID: <20130827192640.GB31552@rhlx01.hs-esslingen.de>
References: <521AED72.8050105@xs4all.nl>
 <20130827174156.GA19152@rhlx01.hs-esslingen.de>
 <CAMuHMdWNHdknFyz3NXJJZJrSL61Bi-v-34hVh4-8eS2ArnBaKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWNHdknFyz3NXJJZJrSL61Bi-v-34hVh4-8eS2ArnBaKA@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 09:18:37PM +0200, Geert Uytterhoeven wrote:
> On Tue, Aug 27, 2013 at 7:41 PM, Andreas Mohr <andi@lisas.de> wrote:
> > while :; do clear; cat /proc/interrupts; sleep 1; done
> 
> watch cat /proc/interrupts
> 
> (yes, I spent ca. 15 years of my life using a similar loop ;-)

Urgh, how did I manage to forget about that? :)

However my solution surely achieves faster more better colorfully HD
since it's base POSIX shell rather than heavy-handed "watch" dependency :)

Andreas Mohr
