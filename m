Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbaFWToj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:44:39 -0400
Received: from relay.parallels.com ([195.214.232.42]:45664 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbaFWToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:44:37 -0400
Date: Mon, 23 Jun 2014 23:44:29 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 0/4] timerfd c/r support, v4
Message-ID: <20140623194429.GB23651@paralelels.com>
References: <20140623185431.396309193@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20140623185431.396309193@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.24.25.246]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:54:31PM +0400, Cyrill Gorcunov wrote:
> Hi guys, here is an updated version of c/r support for timerfd files. The main change
> is in how @ticks are restored in patch 3 -- I switched to ioctl code, which is wrapped
> with CONFIG because I still think that while there is only one ioctl designated
> solely for c/r needs no need to build it all the time until explicitly requested.
> Please take a look once time permit. Comments are highly appreciated.
> Also note the last patch is for man-page git repo, not for kernel.
> 
> Thanks!

Acked-by: Andrew Vagin <avagin@parallels.com>
