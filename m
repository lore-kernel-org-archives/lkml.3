Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaBFFev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:34:51 -0500
Received: from science.horizon.com ([71.41.210.146]:26334 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755577AbaBFFet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:34:49 -0500
Date: 6 Feb 2014 00:34:47 -0500
Message-ID: <20140206053447.4668.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: nate@thatsmathematics.com, sbsiddha@gmail.com
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
Cc: hpa@zytor.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux@horizon.com, maarten-baert@hotmail.com, mingo@kernel.org,
        priikone@iki.fi, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, x86@kernel.org
In-Reply-To: <alpine.DEB.2.10.1402052224200.2702@minerva.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 3.13 plus this patch: boots and fixes the testcase I reported (core dump 
> on ecrypt).
> 
> Tested-by: Nate Eldredge <nate@thatsmathematics.com>

It's looking good for me so far, too.  I'm slower to reproduce, so I'd
like a couple more days before signing off on it, but no complaints yet.
