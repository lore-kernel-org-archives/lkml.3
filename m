Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab3GFNuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 09:50:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60565 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3GFNuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 09:50:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [Regression in 3.10] Garbage displayed after resume on Acer Aspire S5
Date: Sat, 06 Jul 2013 15:59:49 +0200
Message-ID: <1511667.B4N0cEgdH9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just started to play with a new Acer Aspire S5 test box and noticed that
garbage is displayed after resume from suspend to RAM with the 3.10 kernel
(under KDE 4.10.3 on openSUSE 12.3).  The display corruption goes away after
killing X and restarting it.

The CPU is a Core i5-3317U (Ivy Bridge), i915 graphics.

That doesn't happen with 3.9 (same config otherwise).  It also doesn't happen
with my older Sandy Bridge-based box (with 3.10), so I suspect Ivy Bridge
specifics.

Is this known?  Do you want me to bisect?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
