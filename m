Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbaGDGUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:20:20 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47142 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaGDGUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:20:19 -0400
Date: Fri, 4 Jul 2014 16:19:14 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Nick Krause <xerofoify@gmail.com>
cc: sammy@sammy.net, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Remove FIXME comment in file sun3_pgalloc.h
In-Reply-To: <CAPDOMVhvuvWesMev-5dOFA78Sf67o0kUCXR2VkdhE-xeiYQ=6w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1407041615280.8188@nippy.intranet>
References: <1404351693-5588-1-git-send-email-xerofoify@gmail.com> <alpine.LNX.2.00.1407041125060.15901@nippy.intranet> <CAPDOMVhvuvWesMev-5dOFA78Sf67o0kUCXR2VkdhE-xeiYQ=6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 4 Jul 2014, Nick Krause wrote:

> What are these two lines for them another compile issue?

I don't see why those two lines are important.

> >> -/* FIXME - when we get this compiling */
> >>  /* erm, now that it's compiling, what do we do with it? */
> >>  #define _KERNPG_TABLE 0

Presumably it is the third line that the "FIXME" refers to.

I didn't write this code, but obviously it isn't supposed to be read as 

/* FIXME - this comment needs to be deleted */

-- 
