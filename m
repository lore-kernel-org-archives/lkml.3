Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaHEW3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:29:40 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39789 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaHEW3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:29:38 -0400
MIME-Version: 1.0
Date: Tue, 5 Aug 2014 15:29:38 -0700
Message-ID: <CAK2H+ecXX5h6t8MyeEVdJR6JXMNbKYvgD3oaeVLakYkixs31eA@mail.gmail.com>
Subject: 3.14.14 - failed command: SET FEATURES
From: Mark Knecht <markknecht@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   End user type here. This seems to be a sort of old issue that
others have seen but it's never shown up here at home as far as I
know.

   I typically run long-term kernels and have recently been running
the 3.12 series until a few days ago when I got around to building
3.14.14. The kernel seemed to work fine but I saw the 'failed command'
messages posted below in dmesg. I've not seen them before.

   A little searching suggested trying

touch /etc/pm/power.d/harddrive

which did remove the messages.

   No problem for me at this point but I figured I'd report it in case
creating the harddrive file wasn't the right way to handle it.

   If anyone wants config files or anything else let me know.

Cheers,
Mark

[   16.685795] sky2 0000:07:00.0 eth0: enabling interface
[   18.552776] sky2 0000:07:00.0 eth0: Link is up at 100 Mbps, full
duplex, flow control both
[   19.621150] nvidia 0000:02:00.0: irq 72 for MSI/MSI-X
[   20.082994] nvidia 0000:04:00.0: irq 73 for MSI/MSI-X
[   39.534163] ata1.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0
[   39.534166] ata1.00: irq_stat 0x40000001
[   39.534168] ata1.00: failed command: SET FEATURES
[   39.534172] ata1.00: cmd ef/05:fe:00:00:00/00:00:00:00:00/40 tag 17
         res 51/04:fe:00:00:00/00:00:00:00:00/40 Emask 0x1 (device error)
[   39.534174] ata1.00: status: { DRDY ERR }
[   39.534175] ata1.00: error: { ABRT }
[   39.547169] ata1.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0
[   39.547171] ata1.00: irq_stat 0x40000001
[   39.547173] ata1.00: failed command: SET FEATURES
[   39.547177] ata1.00: cmd ef/c2:00:00:00:00/00:00:00:00:00/40 tag 18
         res 51/04:00:00:00:00/00:00:00:00:00/40 Emask 0x1 (device error)
[   39.547178] ata1.00: status: { DRDY ERR }
[   39.547180] ata1.00: error: { ABRT }
[   39.550299] ata1.00: configured for UDMA/133
[   39.550301] ata1: EH complete
[   39.564188] ata2.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0
[   39.564191] ata2.00: irq_stat 0x40000001
[   39.564195] ata2.00: failed command: SET FEATURES
[   39.564202] ata2.00: cmd ef/05:fe:00:00:00/00:00:00:00:00/40 tag 14
         res 51/04:fe:00:00:00/00:00:00:00:00/40 Emask 0x1 (device error)
[   39.564205] ata2.00: status: { DRDY ERR }
[   39.564208] ata2.00: error: { ABRT }
[   39.577195] ata2.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0
[   39.577199] ata2.00: irq_stat 0x40000001
[   39.577204] ata2.00: failed command: SET FEATURES
[   39.577211] ata2.00: cmd ef/c2:00:00:00:00/00:00:00:00:00/40 tag 15
         res 51/04:00:00:00:00/00:00:00:00:00/40 Emask 0x1 (device error)
[   39.577215] ata2.00: status: { DRDY ERR }
[   39.577217] ata2.00: error: { ABRT }
[   39.580390] ata2.00: configured for UDMA/133
[   39.580396] ata2: EH complete
[   39.677366] ata11.00: configured for UDMA/100
[   39.683543] ata11.01: configured for UDMA/133
[   39.683550] ata11: EH complete
[   39.931147] ata12.00: configured for UDMA/133
[   39.937414] ata12.01: configured for UDMA/133
[   39.937417] ata12: EH complete
[   40.084802] ata12.00: configured for UDMA/133
[   40.091658] ata12.01: configured for UDMA/133
[   40.091664] ata12: EH complete
[   40.171143] ata13.00: configured for UDMA/133
[   40.171147] ata13: EH complete
[   40.244515] ata14.00: configured for UDMA/133
[   40.244520] ata14: EH complete
[   41.278147] EXT4-fs (md3): re-mounted. Opts: commit=60,commit=0
