Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab3GLXjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 19:39:17 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:57474 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3GLXjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 19:39:16 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 12 Jul 2013 16:38:54 -0700
X-Google-Sender-Auth: x_AZB1rdrMv_9hWb3bx1Gsopsh4
Message-ID: <CAB=NE6XyC0Svxh8yeVNvnpdkVBTWEAcmi8wZocc6MC=kxLs2iw@mail.gmail.com>
Subject: [ANN] backports-v3.10 released - first release!
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kicked out the first Linux kernel backports release under the new
project name, "backports" that hopefully clarifies this a generic
backport project now. Backported subsystems in this release:

  * Ethernet
  * Wireless
  * Bluetooth
  * NFC
  * GPU
  * Media
  * Regulator

Go read the git tree for a full ChangeLog, moving forward I won't be
providing those anymore. The highlights are  Johannes Berg's awesome
work on adding full Kconfig support, which makes you can use 'make
menuconfig', and his huge rework of the entire build system, and
kicking us into pythonifying everything non-user / build related.
Other obvious highlights are huge ongoing contributions by Hauke
without which any of this wouldn't have happened. Thierry Escande
threw in NFC, and we also now have Media and Regulator subsystems
backported. We should have now over 830 drivers backported.

Under the new build system users should query 'make help' and 'make
defconfig-help'.

Go download the new release [0] and if you want something more fancy
check out the new shiny but temporary release page [1].

[0] http://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.10/backports-3.10-1.tar.bz2
[1] http://drvbp1.linux-foundation.org/~mcgrof/rel-html/backports/

  Luis
