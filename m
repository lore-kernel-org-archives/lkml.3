Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3F2AbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 20:31:23 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36282 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3F2AbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 20:31:22 -0400
Date: Fri, 28 Jun 2013 17:31:21 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 3.10
Message-ID: <alpine.DEB.2.00.1306281726140.1830@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following patch from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This is a recently spotted regression in the snapshot behavior.... it 
turns out several tests weren't being run in the nightlies so this took a 
while to spot.

Thanks!
sage


----------------------------------------------------------------
Josh Durgin (1):
      rbd: send snapshot context with writes

 drivers/block/rbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
