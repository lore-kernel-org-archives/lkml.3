Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaJZOLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 10:11:54 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:44027 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaJZOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 10:11:53 -0400
Date: Sun, 26 Oct 2014 15:11:45 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
Message-ID: <20141026141144.GA22911@sesse.net>
References: <20141003194428.GA27084@sesse.net>
 <1412782664.5179.75.camel@marge.simpson.net>
 <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
 <1412791184.5173.11.camel@marge.simpson.net>
 <alpine.DEB.2.11.1410241724370.5308@nanos>
 <1414168721.5308.3.camel@marge.simpson.net>
 <20141026103918.GA5259@sesse.net>
 <1414329375.5304.20.camel@marge.simpson.net>
 <1414331916.5304.23.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414331916.5304.23.camel@marge.simpson.net>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 02:58:36PM +0100, Mike Galbraith wrote:
> Can you try the below?

I can bake it into the kernel the next time I boot, but that is unlikely to
be anytime soon, I'm afraid. I'm maybe a bit surprised nobody else can
reproduce my issue; I assume it won't help if I give out shell access
somehow.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
