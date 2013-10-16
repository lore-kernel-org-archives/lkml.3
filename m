Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab3JPTYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:24:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3JPTYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:24:10 -0400
Date: Wed, 16 Oct 2013 12:24:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-pwm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, thierry.reding@gmail.com,
        arnd@arndb.de
Subject: Re: [PATCH v2] pwm: add ep93xx PWM support
Message-ID: <20131016192409.GA19574@kroah.com>
References: <201310151840.03569.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310151840.03569.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 06:40:03PM -0700, H Hartley Sweeten wrote:
> Remove the non-standard EP93xx PWM driver in drivers/misc and add
> a new driver for the PWM controllers on the EP93xx platform based
> on the PWM framework.
> 
> These PWM controllers each support 1 PWM channel with programmable
> duty cycle, frequency, and polarity inversion.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
