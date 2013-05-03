Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763418Ab3ECUBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:01:41 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:41920 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3ECUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:01:38 -0400
Message-ID: <5184179D.5050407@pobox.com>
Date: Fri, 03 May 2013 16:01:33 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Subject: libata maintainership change
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linux has really found its groove.

When I first got involved in Linux, there was no PCI API (now called the 
hotplug or device API), and patch submission was a moderately painful 
process of throwing spaghetti at a wall: sending and resending, with 
both Linus and maintainers having to manually resolve merge conflicts. 
<shiver>

It was a real fight to get any Linux hardware support at all.  The vast 
amount of hardware documentation was locked away or simply unavailable.

Working on memory management or filesystems or scheduling was always the 
Sexy Rock Star PhD work that attracted engineers.  OTOH, I felt, device 
drivers were ignored as boring, unsexy grunt work.  Which, ok, maybe it 
was.  Each new device driver, though, spread Linux to more and greater 
locales.  Alan Cox and Don Becker did enormous heavy lifting back then. 
  Now Linux is where it is today, with most hardware vendors actively 
seeking open source driver support (except NVIDIA, natch).  The kernel 
has come a long way.

Time for new open source pastures outside the kernel, for me.  SATA is 
slowly getting unexciting to the world.  Which, really, just means the 
brand new technology has reached a usable plateau.  :)  And maybe in a 
few years, with directly attached PCI-NextGenSuperFastExpress storage, 
ATA and SCSI will be distant memories.

Until such time as block-based storage disappears from this earth, the 
brave Sir Tejun, basically the libata co-author at this point, has 
agreed to be a target for slings and arrows known as libata patches.

All the best,

	Jeff


