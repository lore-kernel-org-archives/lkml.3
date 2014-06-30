Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaF3ThV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:37:21 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:39406 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260AbaF3ThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:37:20 -0400
Date: Mon, 30 Jun 2014 21:37:16 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Alexander Holler <holler@ahsoftware.de>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Whitmore <arigead@gmail.com>
Subject: Re: [PATCH 0/2][RFC] Try to handle hctosys w/ rtc modules
Message-ID: <20140630213716.36dd4227@linux.lan.towertech.it>
In-Reply-To: <20140628205433.0ef4a8cf28a7fe4861a733dd@gmx.de>
References: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
	<53AE6C3C.5090308@ahsoftware.de>
	<53AE6FA2.7000808@ahsoftware.de>
	<20140628205433.0ef4a8cf28a7fe4861a733dd@gmx.de>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 20:54:33 +0200
Marc Dietrich <marvin24@gmx.de> wrote:

> > Besides that the current hctosys-mechanism doesn't really work with 
> > hot-plugable devices at all. Guess what N will be when you unplug and 
> > plug in such a RTC again.  
> 
> We have a patch in the kernel which binds the rtc number to the
> hw device, so this even works for hotpluggable devices (at least on
> systems supporting device-tree). Not sure what your needs are.

 I'm still not sure about how to solve this, maybe it would be better to
 identify the hctosys device that should be used at boot with 
 a different identifier than rtcX (and move the option to the kernel command line)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

