Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaBWVNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:13:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:52037 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaBWVNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:13:15 -0500
Date: Sun, 23 Feb 2014 22:13:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Vasilyev <pavel@pavlinux.ru>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.12-rt19
In-Reply-To: <530A4C00.5070205@pavlinux.ru>
Message-ID: <alpine.DEB.2.02.1402232211300.21251@ionos.tec.linutronix.de>
References: <20140223184727.GA12442@linutronix.de> <530A486A.2000802@pavlinux.ru> <530A4C00.5070205@pavlinux.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1827808936-1393190002=:21251"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1827808936-1393190002=:21251
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 23 Feb 2014, Pavel Vasilyev wrote:
> 23.02.2014 23:13, Pavel Vasilyev пишет:
> 
> > But not  -rt1, -rt2, -rt3 -rt4, .... -rt99
> 
> Or
> 
> 3.12-rt1,
> 3.12-rt2,
> ...
> 3.12-rt33,
> ...
> 3.12-rt111,
> ...
> 3.12-rt999
> ...
> 
> Now, to have to roll back all my changes, then work -rt patch,
> then impose SUBLEVEL mainline diff, then last -rt patch, then my сhanges.

So we need a different numbering scheme just because your workflow is
completely backwards?

Thanks,

	tglx
--8323329-1827808936-1393190002=:21251--
