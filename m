Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaGLAWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:22:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbaGLAWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:22:35 -0400
Date: Fri, 11 Jul 2014 17:27:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch 47/55] hangcheck-timer: Use ktime_get_raw_ns()
Message-ID: <20140712002703.GC17292@kroah.com>
References: <20140711133623.530368377@linutronix.de>
 <20140711133709.245458528@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711133709.245458528@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:45:08PM -0000, Thomas Gleixner wrote:
> Use the nanoseconds based interface instead of converting timespecs.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
