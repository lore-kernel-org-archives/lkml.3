Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaKYTMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:12:09 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55324 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaKYTMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:12:06 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v2] omap: i2c: don't check bus state IP rev3.3 and earlier
References: <20141124210809.GG2817@atomide.com>
	<1416867655-22232-1-git-send-email-al.kochet@gmail.com>
Date: Tue, 25 Nov 2014 11:12:02 -0800
In-Reply-To: <1416867655-22232-1-git-send-email-al.kochet@gmail.com>
	(Alexander Kochetkov's message of "Tue, 25 Nov 2014 02:20:55 +0400")
Message-ID: <7hzjbfjdrx.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Kochetkov <al.kochet@gmail.com> writes:

> Commit 903c3859f77f9b0aace551da03267ef7a211dbc4 ("i2c: omap: implement
> workaround for handling invalid BB-bit values") introduce the error result
> in boot test fault on OMAP3530 boards
>
> The patch fix the error (disable i2c bus test for OMAP3530).
>
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Fixes: 903c3859f77f9b0aace551da03267ef7a211dbc4
> Reported-by: Kevin Hilman <khilman@kernel.org>
> Tested-by: Tony Lindgren <tony@atomide.com>

Tested-by: Kevin Hilman <khilman@linaro.org>

I tested DT and legacy boot on 3430/n900, 3530/beagle and
3530/overo-tobi.  All boot fine.

Kevin
