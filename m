Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaKZWaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:30:10 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37163 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaKZWaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:30:07 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling invalid BB-bit values
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141124194759.GG2757@atomide.com>
Date: Thu, 27 Nov 2014 01:30:03 +0300
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <72E65902-3FA7-4845-BF9B-B6CA79E0D61B@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com> <1416685634-5864-1-git-send-email-al.kochet@gmail.com> <1416685634-5864-3-git-send-email-al.kochet@gmail.com> <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com> <47A1A441-952C-4AC3-859C-5A8E405767E0@gmail.com> <20141124194759.GG2757@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tony!

24.11.2014 22:47, Tony Lindgren <tony@atomide.com> *:

> If you post a patch, I can test boot with it. Looks like the failing
> ones have i2c rev3.3 on 34xx vs rev4.4 on 36xx.

> So I doubt we just want to change the test for for a higher rev number
> for  OMAP_I2C_REV_ON_3430_3530.

You 100% right here.

Functional mode bits are unimplemented in the SYSTEST register on omap3530.
"10:5 Reserved Write 0s for future compatibility. Read returns 0."
That was the reason.

My fault.
Thank you for giving right directions.
Thanks Kevin for running test, so I could debug the reason.

Regards,
Alexander.

