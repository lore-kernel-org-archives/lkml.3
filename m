Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3E0P36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:29:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:47795 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3E0P35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:29:57 -0400
Date: Mon, 27 May 2013 17:29:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG
 compile
In-Reply-To: <51A36FB3.9050607@redhat.com>
Message-ID: <alpine.LFD.2.02.1305271729170.4220@ionos>
References: <1361563736-28241-1-git-send-email-prarit@redhat.com> <alpine.LFD.2.02.1305271200220.4220@ionos> <51A36FB3.9050607@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Prarit Bhargava wrote:

> 
> 
> On 05/27/2013 06:00 AM, Thomas Gleixner wrote:
> > On Fri, 22 Feb 2013, Prarit Bhargava wrote:
> > 
> >> If I explicitly disable the clocksource watchdog in the x86 Kconfig,
> > 
> > And why do you want to do that?
> 
> Hey Thomas, I was debugging something and stumbled across this.
> 
> IIRC the issue was that there some weirdness on a series of new AMD systems and
> unfortunately the watchdog would fire and switch clocksources on me :(  That
> resulted in me not being able to debug the HW because the clocksource I wanted
> was no longer available.

tsc=reliable on the kernel command line kills the watchdog
requirement.

Thanks,

	tglx
