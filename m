Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab3BYD5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:57:21 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53000 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab3BYD5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:57:20 -0500
Date: Sun, 24 Feb 2013 19:58:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, thierry.reding@avionic-design.de, rob@landley.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC] pwm: add sysfs interface
Message-ID: <20130225035806.GA7911@kroah.com>
References: <1361284061-2874-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361284061-2874-1-git-send-email-larsi@wh2.tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 03:27:41PM +0100, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This adds a simple sysfs interface to the pwm subsystem. It is
> heavily inspired by the gpio sysfs interface.
> 
>         /sys/class/pwm
>                 /export ... asks the kernel to export a PWM to userspace
>                 /unexport ... to return a PWM to the kernel
>             /pwmN ... for each exported PWM #N
>             /duty_ns ... r/w, length of duty portion
>             /period_ns ... r/w, length of the pwm period
>             /polarity ... r/w, normal(0) or inverse(1) polarity
>                                only created if driver supports it
>             /run ... r/w, write 1 to start and 0 to stop the pwm
>         /pwmchipN ... for each pwmchip; #N is its first PWM
>             /base ... (r/o) same as N
>             /ngpio ... (r/o) number of PWM; numbered N .. MAX_PWMS

You have to document this all in the Documentation/ABI/ directory for
sysfs files. Please do that in your next version of this patch.

thanks,

greg k-h
