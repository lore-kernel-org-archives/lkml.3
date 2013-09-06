Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab3IFTMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:12:55 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61993 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3IFTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:12:54 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/5] ARM: SoC updates for 3.12
Date: Fri,  6 Sep 2013 12:10:00 -0700
Message-Id: <1378494605-14990-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the first batch of arm-soc branches for 3.12. Besides this we
have two "regular" and one small branch that we'll send in a second set.

Nothing controversial, just more of the same as the last several releases:
- More conversions over to device-tree
- More removal of board code (and a bit of addition)
- More SoCs supported:
  - Allwinner A20/A31
  - TI DRA7
- Power management code for cpu and cluster power management on VExpress
- Power management code for low-power CPU states on Tegra

There's also some cleanups, removal of ARM local timer API, removal of
unused OMAP headers and other goodies.

A few conflicts, nothing too hard to deal with. They're documented in
each pull email.

I've pushed a "test-merge" branch to the same repo with my resolutions
to them in case you want to compare.


Thanks!

-Olof

