Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbaF3ToA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:44:00 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48170 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaF3Tn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:43:57 -0400
Date: Mon, 30 Jun 2014 23:43:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 0/4] timerfd c/r support, v4
Message-ID: <20140630194354.GB2305@moon>
References: <20140623185431.396309193@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623185431.396309193@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:54:31PM +0400, Cyrill Gorcunov wrote:
>
> Hi guys, here is an updated version of c/r support for timerfd files. The main change
> is in how @ticks are restored in patch 3 -- I switched to ioctl code, which is wrapped
> with CONFIG because I still think that while there is only one ioctl designated
> solely for c/r needs no need to build it all the time until explicitly requested.
> Please take a look once time permit. Comments are highly appreciated.
> Also note the last patch is for man-page git repo, not for kernel.

Gentlemen, could you please point me if there something preventing the
series from being picked up? Or there some way to improve the series?
