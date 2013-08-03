Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3HCMoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 08:44:34 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:53552 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3HCMoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 08:44:32 -0400
Date: Sat, 3 Aug 2013 15:44:26 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org
Subject: 3.11-rc3+git: __divdi3 undefined on powerpc (from radeon)
Message-ID: <alpine.SOC.1.00.1308031534390.1352@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to compile v3.11-rc3-288-gabe0308 on powerpc 32-bit, 
it failed with the following linking error:

ERROR: "__divdi3" [drivers/gpu/drm/radeon/radeon.ko] undefined!

Some new 64-bit division in radeon that is not implemented on 32-bit 
powerpc?

This is new - 3.11-rc3 worked fine.

-- 
Meelis Roos (mroos@linux.ee)
