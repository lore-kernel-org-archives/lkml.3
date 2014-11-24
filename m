Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaKXTjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:39:48 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:37058 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaKXTjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:39:46 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling invalid BB-bit values
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com>
Date: Mon, 24 Nov 2014 22:39:42 +0300
Cc: Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Alexander Kochetkov <al.kochet@gmail.com>,
        Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <47A1A441-952C-4AC3-859C-5A8E405767E0@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com> <1416685634-5864-1-git-send-email-al.kochet@gmail.com> <1416685634-5864-3-git-send-email-al.kochet@gmail.com> <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com>
To: Kevin Hilman <khilman@kernel.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


24 нояб. 2014 г., в 22:08, Kevin Hilman <khilman@kernel.org> написал(а):

> This patch recently hit linux-next (as commit 903c3859f77f) and boot
> breakage[1] in next-20141124 on OMAP3530 Beagle and Overo/Tobi boards
> was bisected down to this commit.
> 
> Kevin
> 
> [1] http://status.armcloud.us/boot/?next-20141124&omap


Could someone advice with debugging on OMAP3530?

I'd like to apply one one more commit to see events during boot and
see actual signals on wire (during of timeout)?

Otherwise, commit must dropped (or rewritten such way it is disabled by default).


24 нояб. 2014 г., в 22:13, Wolfram Sang <wsa@the-dreams.de> написал(а):

> OK, giving Alexander some time for a fix. If it can't be found, I'll
> revert this patch. Thanks!

What deadline?

Alexander.



