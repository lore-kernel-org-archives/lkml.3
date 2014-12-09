Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaLIVdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:33:50 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:59142 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaLIVds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:33:48 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-fbdev@vger.kernel.org
Subject: Compiled tridentfb hangs but distribution kernel works fine
Date: Tue, 9 Dec 2014 22:33:16 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201412092233.17030.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm doing some work on tridentfb driver but encountered a weird problem.

When I compile custom kernel with tridentfb, it hangs with Blade3D card (ID 
0x9880) in blade_image_blit(). The screen is blank with some artifacts and 
machine does not respond to ping or keyboard. However, it can be rebooted by 
Alt+SysRq+B. It works fine with other cards (3DImage 9750 and CyberBlade XP) 
with no blit implementation. Commenting out contents of blade_image_blit() 
function makes the hang go away (nothing useful on the screen, of course).

The weird thing is that the Blade3D card works fine when I load Debian 
kernels! Debian 3.16-0.bpo.3-686-pae works fine but when I compile 3.16 
kernel, it hangs.

Any ideas?


-- 
Ondrej Zary
