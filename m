Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaFICS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 22:18:29 -0400
Received: from ns.horizon.com ([71.41.210.147]:46661 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754247AbaFICSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 22:18:22 -0400
Date: 8 Jun 2014 22:18:20 -0400
Message-ID: <20140609021820.2038.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range like this safe?
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140609021054.1614.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Summarizing that, time to feed in 32 MiB of zeros (from user-space):
> 
> 0 concurrent reads:  0.356898 0.357693
> 1 concurrent read:   0.505941 0.509075	(+42%)
> 2 concurrent reads:  0.662240 0.657055	(+84%)

Er, wait a minute... I'm not sure which kernel (patched or unpatched)
I did that measurement on.

That may be a completely useless number.  I need to compile some more
kernels and reboot a few more times.  Sorry about that.
