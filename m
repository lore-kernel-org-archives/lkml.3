Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaKXUF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:05:29 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:55128 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaKXUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:05:26 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling invalid BB-bit values
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141124194759.GG2757@atomide.com>
Date: Mon, 24 Nov 2014 23:05:21 +0300
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Kochetkov <al.kochet@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <47749B61-5924-4E56-9931-77B0CFC0AAA0@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com> <1416685634-5864-1-git-send-email-al.kochet@gmail.com> <1416685634-5864-3-git-send-email-al.kochet@gmail.com> <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com> <47A1A441-952C-4AC3-859C-5A8E405767E0@gmail.com> <20141124194759.GG2757@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, I really sorry for that :(

> Just try to boot it with your patch? :)

Yes, may be two-three times (max).
Something (u-boot, may be) leave the bus in the wrong state.
Really strange.

> But the test function should not loop forever in any case I take?

It doesn't loop forever. It finish with message:
"[    3.046691] omap_i2c 48070000.i2c: timeout waiting for bus ready"

> So I doubt we just want to change the test for for a higher rev number
> for  OMAP_I2C_REV_ON_3430_3530.


Yes, I'll do it within 15 minutes.
And later, if it possible, I'd try to see what happens.

Alexander.

