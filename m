Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaG0Gus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 02:50:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43152 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaG0Gur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 02:50:47 -0400
Message-ID: <1406443843.5115.124.camel@marge.simpson.net>
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Matt Joras <dev@mjoras.com>
Cc: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 27 Jul 2014 08:50:43 +0200
In-Reply-To: <53D48919.6060407@mjoras.com>
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
	 <53D48919.6060407@mjoras.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-26 at 22:07 -0700, Matt Joras wrote: 
> Nick,
> 
> I could be wrong but I doubt this is symptomatic of a "kernel bug" as 
> you seem to think. Are you saying that the music stutters during a 
> transfer operation to your external hard drive? I.e. the music playback 
> in Clementine stutters while you are writing to the disk the music files 
> are on? If so, that doesn't really sound like a bug to me, especially 
> not a sound driver bug.

Not a sound driver bug, no, but is perhaps a latency issue if buffering
is not ridiculously tiny.  It's a difficult to explore, but worth it.

-Mike

