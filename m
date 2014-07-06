Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaGFXng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 19:43:36 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61492 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaGFXne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 19:43:34 -0400
Date: Sun, 6 Jul 2014 16:43:56 -0700
From: Olof Johansson <olof@lixom.net>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, arm@kernel.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH v2 1/3] arm: multi_v7: enable igb, stmpe, lm95245, pwm
 leds
Message-ID: <20140706234356.GB5539@quad.lixom.net>
References: <1741a33cd88cd5525f3c50c0e0cacc0853a3512a.1402350905.git.marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1741a33cd88cd5525f3c50c0e0cacc0853a3512a.1402350905.git.marcel@ziswiler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 12:49:50AM +0200, Marcel Ziswiler wrote:
> The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
> i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller, PWM
> LEDs generically accessible from user space and an LM95245 temperature
> sensor chip. The later three can also be found on the Colibri T30
> module.
> 
> While at it move the NEON entry down to its proper place to have it all
> nicely ordered again.
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>

Applied for 3.17.


-Olof
