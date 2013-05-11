Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3EKPLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 11:11:18 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:13399 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab3EKPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 11:11:15 -0400
Date: Sat, 11 May 2013 17:11:11 +0200
From: Philippe De Muyter <phdm@macq.eu>
To: linux-kernel@vger.kernel.org
Subject: AIX LVM support : block/partitions, kpartx, dmraid or lvm2 or ...
Message-ID: <20130511151111.GA31314@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have recently written a read-only support for linux for AIX 3 & 4 lvm
disks, and submitted a patch for the linux block/partitions subsystem,
for which I have no feedback yet.

Now I wonder, as AIX LVM can describe mirrored and splitted logical
volumes, is block/partitions the right place for it ?  It seems that
only contiguous partitions can be described.  Am I mistaken ?
I looked also at kpartx, but it seems to me that kpartx has the same
limitations as block/partitions.

Should I rather make a patch for dmraid or lvm2 or some other tool I
am not aware of ?  What would be the best place for that support ?

I have working code that can generate tables for dmsetup, and I know
there is some demand for AIX LVM and AIX JFS support in linux, but where
should I send it ?

Thanks in advance

Philippe

PS: Of course, AIX LVM support does only make sense if AIX JFS file systems
are supported.  I have written read-only support for cwAIX JFSit also, and
I plan to submit it when I have a solution for AIX LVM, so that the AIX JFS
code can be tested by others.
