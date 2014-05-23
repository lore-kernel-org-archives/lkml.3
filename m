Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaEWIyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:54:45 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:51834 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaEWIyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:54:43 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/4] cpuidle: Remove remaining cpu_idle() references
Date: Fri, 23 May 2014 10:54:21 +0200
Message-Id: <1400835265-21956-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
GIT: Lines beginning in "GIT:" will be removed.
GIT: Consider including an overall diffstat or table of contents
GIT: for the patch you are writing.
GIT: Clear the body content if you don't wish to send a summary.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Thomas,

After all architectures were converted to the generic idle framework,
commit d190e8195b90bc1e65c494fe08e54e9e581bfd16 ("idle: Remove
GENERIC_IDLE_LOOP config switch") removed the last caller of cpu_idle().

This series removes the remaining references to the no-longer existing
cpu_idle() function.

There are still a few references left, but these refer to the generic
mechanism, not to the C function.

  - [PATCH 1/4] idle: Remove cpu_idle() forward declarations
  - [PATCH 2/4] cris: Update comments for generic idle conversion
  - [PATCH 3/4] powerpc: Update comments for generic idle conversion
  - [PATCH 4/4] tile: Update comments for generic idle conversion

Please apply. Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
