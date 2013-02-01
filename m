Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3BAWMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:12:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab3BAWMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:12:13 -0500
Date: Fri, 1 Feb 2013 14:12:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: "GMEINER.Christian" <C.GMEINER@bachmann.info>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH] leds-ot200: Fix error caused by shifted mask
Message-Id: <20130201141211.1adadfe5.akpm@linux-foundation.org>
In-Reply-To: <CAH9NwWdciqHSkkMSk4CW4XX+d6JSZBnvw52Svu8M4o-PGMQsDA@mail.gmail.com>
References: <1358928657-15781-1-git-send-email-christian.gmeiner@gmail.com>
	<7AFBFD79B857054D97821A9BD3FBFA9744D05BD2@ATFKEX06.bachmann.at>
	<CAH9NwWdciqHSkkMSk4CW4XX+d6JSZBnvw52Svu8M4o-PGMQsDA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013 16:08:15 +0100
Christian Gmeiner <christian.gmeiner@gmail.com> wrote:

> ping

Bryan is handling LEDs patches (see ./MAINTAINERS).  Without a cc he
presumably missed this in the lkml flood.

> 2013/1/23 GMEINER.Christian <C.GMEINER@bachmann.info>:
> >> -----Urspr__ngliche Nachricht-----
> >> Von: Christian Gmeiner [mailto:christian.gmeiner@gmail.com]
> >> Gesendet: Mittwoch, 23. Januar 2013 09:11
> >> An: linux-next@vger.kernel.org; akpm@linux-foundation.org;
> >> rpurdie@rpsys.net; linux-kernel@vger.kernel.org; GMEINER.Christian
> >> Cc: Christian Gmeiner
> >> Betreff: [PATCH] leds-ot200: Fix error caused by shifted mask
> >>
> >> During the development of this driver an in-house register documentation
> >> was used. The last weeks some integration tests were done and this problem
> >> was found. It turned out that the released register documentation is wrong.
> >>
> >> The fix is very simple: shift all masks by one.
> >>

The changelog failed to describe the effects of the bug it fixes.  This
is a grave (and all too common) omission; it makes it difficult for
others to determine whether the patch should be backported into earlier
kernels.

So, please tell us.  And feel free to explain whether you believe the
fix should be backported.

