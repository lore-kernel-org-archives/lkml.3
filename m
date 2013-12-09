Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654Ab3LIHtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:49:53 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58648 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3LIHtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:49:51 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 8 Dec 2013 23:49:38 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Stephane Eranian <eranian@google.com>,
        Pawel Moll <pawell.moll@arm.com>, Olof Johansson <olof@lixom.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] drivers: char: Add a dynamic clock for the trace
 clock
Message-ID: <20131209074933.GA2922@jtriplet-mobl1>
References: <1386376451-24593-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386376451-24593-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 04:34:11PM -0800, Sonny Rao wrote:
> Based on a suggestion from John Stultz.
> 
> This adds a dynamic clock device which can be used with clock_gettime
> to sample the clock source used for time stamping trace events in the
> kernel.  The only use for this clock source is to associate user space
> events with kernel events on a given kernel.  It is explicitly not
> supposed to be used as a generic time source and won't necessarily be
> consistent between kernels.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
