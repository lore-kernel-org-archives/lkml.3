Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaGOVUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:20:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:51310 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaGOVU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:20:29 -0400
Date: Tue, 15 Jul 2014 23:20:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 0/4] timerfd c/r support, v4
In-Reply-To: <20140715211800.GM23835@moon>
Message-ID: <alpine.DEB.2.10.1407152319590.24854@nanos>
References: <20140623185431.396309193@openvz.org> <20140630194354.GB2305@moon> <20140715135445.GJ23835@moon> <alpine.DEB.2.10.1407151811050.24854@nanos> <20140715162501.GK23835@moon> <alpine.DEB.2.10.1407152306430.24854@nanos> <20140715211413.GL23835@moon>
 <alpine.DEB.2.10.1407152315350.24854@nanos> <20140715211800.GM23835@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2014, Cyrill Gorcunov wrote:

> On Tue, Jul 15, 2014 at 11:16:23PM +0200, Thomas Gleixner wrote:
> > > 
> > > Maybe it's because of new -rc? Letme check...
> > 
> > No, it's because its against an older version of your patches which
> > lack the #ifdef PROC_FS around the show function ....
> 
> Crap. Sorry. Thomas, I'm fetching -rc5 now, I suppose better will
> be if I rebase the whole series and resend. Sounds good?

No rebase necessary. 1&2 apply fine. It's home made wreckage :)
 
