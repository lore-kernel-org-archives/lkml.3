Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab3ITSSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:18:22 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:52217 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab3ITSSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:18:20 -0400
Date: Fri, 20 Sep 2013 19:18:19 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Joe Perches <joe@perches.com>, Geert Uytterhoeven <geert@linux-m68k.org>
cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [PATCH 2/2] framebuffer: Remove pmag-aa-fb
In-Reply-To: <CAMuHMdW6R5qTJ0uvsUUaYBZAqFcNshPsXeMbz5hwqq5UOkJr-g@mail.gmail.com>
Message-ID: <alpine.LFD.2.03.1309201907380.8379@linux-mips.org>
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>        <6f500d88eb23fd9a4cfc5583f5ca17bc5f58fe24.1379641901.git.joe@perches.com> <CAMuHMdW6R5qTJ0uvsUUaYBZAqFcNshPsXeMbz5hwqq5UOkJr-g@mail.gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe, Geert --

 Can we please wait with that a few days?  I've been reviving DECstation 
bits recently but the generic stuff took priority (thankfully little 
bitrot there, the port generally works, except from the 64-bit mode).  I 
think it'll make more sense if we have an incremental diff in the repo 
rather than a complete removal, followed with a readdition with necessary 
adjustments.

> Adding Maciej and linux-mips

 Thanks for (re-)pinging, I've been trying to push things forwards as time 
permits.

  Maciej
