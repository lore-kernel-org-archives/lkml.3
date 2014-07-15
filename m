Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaGOVSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:18:06 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33381 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaGOVSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:18:04 -0400
Date: Wed, 16 Jul 2014 01:18:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 0/4] timerfd c/r support, v4
Message-ID: <20140715211800.GM23835@moon>
References: <20140623185431.396309193@openvz.org>
 <20140630194354.GB2305@moon>
 <20140715135445.GJ23835@moon>
 <alpine.DEB.2.10.1407151811050.24854@nanos>
 <20140715162501.GK23835@moon>
 <alpine.DEB.2.10.1407152306430.24854@nanos>
 <20140715211413.GL23835@moon>
 <alpine.DEB.2.10.1407152315350.24854@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407152315350.24854@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 11:16:23PM +0200, Thomas Gleixner wrote:
> > 
> > Maybe it's because of new -rc? Letme check...
> 
> No, it's because its against an older version of your patches which
> lack the #ifdef PROC_FS around the show function ....

Crap. Sorry. Thomas, I'm fetching -rc5 now, I suppose better will
be if I rebase the whole series and resend. Sounds good?
