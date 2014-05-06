Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaEFWFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:05:06 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:39323 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaEFWFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:05:05 -0400
Date: Tue, 6 May 2014 23:05:02 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>
cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH 1/2] RTC: rtc-cmos: drivers/char/rtc.c features
 for DECstation support
In-Reply-To: <20140506115458.4010da2e@linux.lan.towertech.it>
Message-ID: <alpine.LFD.2.11.1405062258130.21408@eddie.linux-mips.org>
References: <alpine.LFD.2.11.1404192224250.11598@eddie.linux-mips.org> <20140506115458.4010da2e@linux.lan.towertech.it>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Alessandro Zummo wrote:

> > This brings in drivers/char/rtc.c functionality required for DECstation 
> > and, should the maintainers decide to switch, Alpha systems to use 
> > rtc-cmos.
> 
>  Seems sane. We need to be sure it doesn't break anything
>  on non-Alpha machines. Did you test it on x86? It would be fine if
>  we can get a couple of Tested-by:

 Thanks for your review.  I can't test x86 easily/immediately, but I'll 
see what I can do, and will also appreciate if people can check that this 
change didn't cause any regressions.  Also Andrew was kind enough to pull 
this patch into his -mm tree, so hopefully any breakage will show up soon.

  Maciej
