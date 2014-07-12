Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaGLAWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:22:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbaGLAWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:22:19 -0400
Date: Fri, 11 Jul 2014 17:26:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch 36/55] misc: ioc4: Use ktime_get_ns()
Message-ID: <20140712002646.GB17292@kroah.com>
References: <20140711133623.530368377@linutronix.de>
 <20140711133708.353543709@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711133708.353543709@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:44:52PM -0000, Thomas Gleixner wrote:
> Replace the ever recurring:
>         ts = ktime_get_ts();
>         ns = timespec_to_ns(&ts);
> with
>         ns = ktime_get_ns();
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Acked-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
