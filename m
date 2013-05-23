Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab3EWMXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:23:06 -0400
Received: from smtp2-1.goneo.de ([212.90.139.83]:43036 "EHLO smtp2-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab3EWMXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:23:04 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 08:23:04 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.841
From: Lars Poeschel <poeschel@lemonage.de>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: [RFC] pwm: add sysfs interface
Date: Thu, 23 May 2013 14:12:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <519DDC5B.4040403@schinagl.nl>
In-Reply-To: <519DDC5B.4040403@schinagl.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231412.15096.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver!

As you are not the first one asking for the status of the pwm sysfs 
interface I post my answer to the linux-kernel list in hope others will 
benefit.

On Thursday 23 May 2013 at 11:07:39, Oliver Schinagl wrote:
> Hi lars,
> 
> I have trouble seeing if your patch has been applied yet to the kernel
> tree. I do see it in patchwork.
> https://patchwork.kernel.org/patch/2163151/
> 
> But don't see sysfs features in
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri
> vers/pwm/core.c

It is not merged and will never be.

> If you haven't had time to take Greg's comments into account, would
> there be a possibility for you to correct those and re-submit?

I already did resubmit an updated version taking Greg's comments into 
account. You can find the thread here:

http://marc.info/?l=linux-kernel&m=136499756101273&w=2
https://patchwork.kernel.org/patch/2387391/

Also this version will not get merged into mainline. I have to do a v2 
according to Thierry's comments. I have planed to do it, but I will not 
find the time during the next say 2 months.

> If not, I'd be happy to pull your patch, fix and re-submit (giving you
> full credit of course).

You're welcome! This is a community project. And there is nothing special 
to pull or something. Just take the patch from patchwork and work on it.
 
> Your sysfs driver feature is quite awesome and makes using PWM's quite
> cool, so that's definitely a good feature to have in the kernel.

Thanks!
Thank you for your interest!

Regards,
Lars
