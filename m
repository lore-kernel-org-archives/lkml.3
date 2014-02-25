Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaBYIgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:36:31 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:47922 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaBYIg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:36:29 -0500
Date: Tue, 25 Feb 2014 09:36:13 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC patch 5/5] timerfd: Expose deferrable mode to user space
Message-ID: <20140225083611.GA4240@netboy>
References: <20140221173936.583477951@linutronix.de>
 <20140221174639.888426320@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221174639.888426320@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 05:56:18PM -0000, Thomas Gleixner wrote:
> Expose the deferrable timer mode to user space by adding a new
> TDF_TIMER_DEFERRABLE flag.
> 
> The deferrable mode is available through the syscall timerfd_settime()
> by handing in TDF_TIMER_IS_DEFERRABLE via the 'flags' argument.
> TFD_TIMER_IS_DEFERRABLE and the other TFD_TIMER_ flags can be ored
> together.

s/TDF_/TFD_/g

Thanks,
Richard
