Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3JLTK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:10:27 -0400
Received: from nm23-vm7.access.bullet.mail.bf1.yahoo.com ([216.109.115.166]:30731
	"EHLO nm23-vm7.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697Ab3JLTK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:10:26 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Oct 2013 15:10:25 EDT
X-Yahoo-Newman-Id: 254380.19288.bm@smtp119.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ursgbG8VM1k7ujPh.Z.J43XYIX2yPJ1g7S7S9DSfPw6eNf7
 W8LyVvhHKwuHrGxzwTWrGsT.IG9frIVTcoWX4vQx.dPSNsSgEsNS47Ii56pl
 P0OoXr9VrUFfDSjAURTruqCNiPpzhWBkLJ1pX.GHPEesKl012huhFhduhdJ0
 Vp6aG6ubH.9ycJYPJGb6IzKGSwqU0RWx2Hkduc.tjX7Z1Z2t4ijRh1gB.tpZ
 p4xWNkvVoLfxlteOnwKyghuaqGJRhWz.RSegbqYBiovgkqVIymrk8rj0.SmI
 XAmQSn8NeduJbaF1dQP.8bb7_8bAMw0M3p_ktrNPPw91oDZgIzg45zYGaJq1
 Ess21akcV0pGH0elX9RnQyO4cuWckZrtV2DIqjSCDi8EFpm5DwAYQQARczwV
 xqF6.t5yHyIijhar9CbL3.DLLp71BkwAghu1lkJKFrR1Z9.h8dJqgZ7qy2WU
 aBTJLkciSGfSu0mYhBB1gE9PjOvwd5PF4dD6HCmys_GqyAgN.doDfGm4_1_B
 Y8Dp0nyVqhV1_OtMbrMRMW5uEoyCBx1gkgPEApB.WkwXi50tK3vXY3Yd_tRr
 GnMuP8_ksJaE-
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-Rocket-Received: from segfault.sh0n.net (shawn.starr@174.112.94.49 with )
        by smtp119.sbc.mail.bf1.yahoo.com with SMTP; 12 Oct 2013 19:03:36 +0000 UTC
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: No longer able to build kernel into RPM on Fedora
Date: Sat, 12 Oct 2013 15:03:32 -0400
Message-ID: <2492370.jKSlzuQ6pe@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.11.2 (Linux/3.12.0-0.rc4.git1.2.fc21.x86_64; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

My usual approach to testing git snapshots of Linus's tree (with custom 
patches applied on top) is to make rpm and install this into my system for a 
clean add/remove of test kernels.

However,  the developers of rpm removed the --target and -ta options, so I 
can't take tarball and build into RPM anymore.

Since I last built custom RPM builds of Linus's tree was likely Fedora 18, it 
seems the option target got removed by 19.

Any ideas, fixes?

Thanks,
Shawn
