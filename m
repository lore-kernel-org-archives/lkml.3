Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaLAVOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:14:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:45171 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:14:08 -0500
Date: Mon, 1 Dec 2014 22:13:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Clayton <chris2553@googlemail.com>
cc: linux-kernel@vger.kernel.org, eternal.n08@gmail.com, keescook@chromium.org,
        hpa@linux.intel.com, hpa@zytor.com, bp@suse.de, mingo@kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Use $(OBJDUMP) instead of plain objdump
In-Reply-To: <547CD413.10803@googlemail.com>
Message-ID: <alpine.DEB.2.11.1412012213140.3961@nanos>
References: <54705C8E.1080400@googlemail.com> <tip-e2e68ae688b0a3766cd75aedf4ed4e39be402009@git.kernel.org> <547CD413.10803@googlemail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014, Chris Clayton wrote:
> Is it planned to get this fix through in time for release of 3.18?
> It appears to have been in -next for a week.

Yes. I missed it for rc7, but its scheduled for 3.18 final.

Thanks,

	tglx
