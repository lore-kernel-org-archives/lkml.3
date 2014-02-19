Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaBSTu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:50:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaBSTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:50:56 -0500
Date: Wed, 19 Feb 2014 20:50:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Henrik Austad <henrik@austad.us>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Henrik Austad <haustad@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH Resend] Expose do_timer CPU via sysctl to userspace as R/W
Message-ID: <20140219195044.GZ14089@laptop.programming.kicks-ass.net>
References: <1392813178-25095-1-git-send-email-henrik@austad.us>
 <alpine.DEB.2.02.1402191730590.4468@ionos.tec.linutronix.de>
 <20140219194355.GA23228@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219194355.GA23228@austad.us>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 08:43:55PM +0100, Henrik Austad wrote:
> The online-part should be taken care of by the cpu_present(), no?

No, cpu_present() only means there is a physical CPU present. It might
be offline.

See the comment in include/linux/cpumask.h
