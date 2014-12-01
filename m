Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaLAAVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:21:54 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:38080 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbaLAAVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:21:53 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Nov 2014 19:21:52 EST
Date: Mon, 1 Dec 2014 01:13:56 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH 4/4] rtc/imxdi: Update driver to address time issues
Message-ID: <20141201011356.7588625d@linux.lan.towertech.it>
In-Reply-To: <CADcy93X+XoKruoS6LJsGevjKpQCNX4BVvjh0rYdGivShGLQfGw@mail.gmail.com>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org>
	<1417089760-26848-5-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1411280019590.3961@nanos>
	<CADcy93X+XoKruoS6LJsGevjKpQCNX4BVvjh0rYdGivShGLQfGw@mail.gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2014 00:20:00 +0800
"pang.xunlei" <pang.xunlei@linaro.org> wrote:

> Anyway, they are ungraceful being there. I'll refine this patchset carefully
> according to your valuable suggestions, and will send out another version.
> 
> Thanks for your review!

 I have quite the feeling those patches will cause headaches
 to a lot of people.
 
 Too many of this stuff seems a copy & paste work, without actually
 looking/thinking to the side effects.

 Is there any particular reason your are pursuing this?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

