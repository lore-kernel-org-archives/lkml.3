Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaGONzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:55:23 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33426 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaGONzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:55:18 -0400
Date: Tue, 15 Jul 2014 17:54:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 0/4] timerfd c/r support, v4
Message-ID: <20140715135445.GJ23835@moon>
References: <20140623185431.396309193@openvz.org>
 <20140630194354.GB2305@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630194354.GB2305@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:43:54PM +0400, Cyrill Gorcunov wrote:
> On Mon, Jun 23, 2014 at 10:54:31PM +0400, Cyrill Gorcunov wrote:
> >
> > Hi guys, here is an updated version of c/r support for timerfd files. The main change
> > is in how @ticks are restored in patch 3 -- I switched to ioctl code, which is wrapped
> > with CONFIG because I still think that while there is only one ioctl designated
> > solely for c/r needs no need to build it all the time until explicitly requested.
> > Please take a look once time permit. Comments are highly appreciated.
> > Also note the last patch is for man-page git repo, not for kernel.
> 
> Gentlemen, could you please point me if there something preventing the
> series from being picked up? Or there some way to improve the series?

Dear sirs, ping?
