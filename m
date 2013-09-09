Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3IIVFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:05:00 -0400
Received: from eurynome.mirbsd.org ([81.169.181.30]:44003 "EHLO
	eurynome.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3IIVE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:04:58 -0400
X-Greylist: delayed 1113 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 17:01:13 EDT
Date: Mon, 9 Sep 2013 20:35:23 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] m68k: Add infrastructure for machine-specific
 get_cycles()
In-Reply-To: <1378754774-25804-1-git-send-email-geert@linux-m68k.org>
Message-ID: <Pine.BSM.4.64L.1309092033110.15325@herc.mirbsd.org>
References: <1378754774-25804-1-git-send-email-geert@linux-m68k.org>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven dixit:

>Currently get_cycles() always returns zero.  As get_cycles() is called to
>add entropy to the random number generator pool, security can be increased

You rock for having something before MIPS ;-) (Note that other
architectures like CRIS are also affected… just, MIPS probably
has the broadest impact… even I have a FreeWRT WLAN AP.)

Sorry I can’t provide any feedback because I’m out of my depth on
both the hardware and the requirements aspect.

bye,
//mirabilos
-- 
Sometimes they [people] care too much: pretty printers [and syntax highligh-
ting, d.A.] mechanically produce pretty output that accentuates irrelevant
detail in the program, which is as sensible as putting all the prepositions
in English text in bold font.	-- Rob Pike in "Notes on Programming in C"
