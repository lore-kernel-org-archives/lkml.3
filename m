Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab3CWOpw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:45:52 -0400
Received: from verein.lst.de ([213.95.11.211]:42297 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3CWOpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:45:51 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Mar 2013 10:45:51 EDT
Date: Sat, 23 Mar 2013 15:37:08 +0100 (MET)
From: Torsten Duwe <duwe@lst.de>
To: David Airlie <airlied@linux.ie>, torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, duwe@lst.de
Subject: [PATCH 0/2] KMS: fix EDID parsing of "detailed timing"
Message-ID: <alpine.LNX.2.02.1303231531520.2097@blackhole.lst.de>
User-Agent: Alpine 2.02 (LNX 1266 2009-07-14)
Organization: LST e.V.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm describing a PAL CRT to my HTPC. Since it uses a 50Hz frame
rate, I had to use a "detailed timing" entry when I crafted an EDID
blob. User space tools properly reproduce the mode line I used
originally, but the kernel gets the vsync position and the frame
rate wrong. Fixes follow.

	Torsten

