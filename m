Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaEHONX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:13:23 -0400
Received: from mail.linuxsystems.it ([2.119.245.41]:57216 "EHLO
	mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaEHONW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:13:22 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2014 10:13:21 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 08 May 2014 16:06:43 +0200
From: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-kernel@vger.kernel.org>
Subject: Please revert 400362f1d8dcfda3562e80e88cfc2a92cffaf9bf
Message-ID: <e84b123e780e21659030c131f4014c36@linuxsystems.it>
User-Agent: Roundcube Webmail/0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Sorry for posting on linux-kernel but from my experience nobody ever 
looks at the kernel bug tracker and I would like to get it fixed before 
3.15 gets released.

https://bugzilla.kernel.org/show_bug.cgi?id=75671

It's funny to read "Still no boot quirks are called, *so it might not 
work well on some devices*" in the commit description: 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=400362f1d8dcfda3562e80e88cfc2a92cffaf9bf
Why does code known to be broken hit the Linus tree? Every new kernel 
release there is something broken to bisect, it doesn't matter if you 
wait for the stable release or not. That's frustrating for an end user.

Thanks,
Niccolò
