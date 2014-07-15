Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaGOVIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:08:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:51269 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaGOVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:08:43 -0400
Date: Tue, 15 Jul 2014 23:08:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 0/4] timerfd c/r support, v4
In-Reply-To: <20140715162501.GK23835@moon>
Message-ID: <alpine.DEB.2.10.1407152306430.24854@nanos>
References: <20140623185431.396309193@openvz.org> <20140630194354.GB2305@moon> <20140715135445.GJ23835@moon> <alpine.DEB.2.10.1407151811050.24854@nanos> <20140715162501.GK23835@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Cyrill Gorcunov wrote:

> On Tue, Jul 15, 2014 at 06:11:58PM +0200, Thomas Gleixner wrote:
> > > 
> > > Dear sirs, ping?
> > 
> > Hmm, I was waiting for a V5, but it seems you just updated that single
> > patch according to the review. I'll pick it up
> 
> Thanks a lot, Thomas!

Sigh. That updated 3/4 patch does not even apply.... 

