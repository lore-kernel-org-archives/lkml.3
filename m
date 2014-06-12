Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbaFLNPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:15:11 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:52487 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933238AbaFLNPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:15:08 -0400
Date: Thu, 12 Jun 2014 15:15:05 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Alexander Holler <holler@ahsoftware.de>
Cc: John Stultz <john.stultz@linaro.org>, John Whitmore <arigead@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rtc/hctosys.c Problem during kernel boot
Message-ID: <20140612151505.03defe29@linux.lan.towertech.it>
In-Reply-To: <539996AA.6020205@ahsoftware.de>
References: <20140611230127.GA28066@griso.site>
	<CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
	<539996AA.6020205@ahsoftware.de>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014 14:01:46 +0200
Alexander Holler <holler@ahsoftware.de> wrote:

> Unfortunately my expieriences with Linux kernel maintainers became even 
> worse and I'm not very eager to post patches. But if someone wants these 
> patches based on 3.15, feel free to notice me.
> 
> To get rid of hctosys, I have 3 patches, and 2 more to implement 
> rtc_read_timeval() for higher resolution clocks.

 Yes, I know the experience might be a painful one.
 Please send the patches and let's see if they fix the issue for John too.
 
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

