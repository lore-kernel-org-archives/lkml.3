Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaC2S2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:28:32 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33301 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaC2S2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:28:30 -0400
Date: Sat, 29 Mar 2014 11:28:30 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 3.14
Message-ID: <alpine.DEB.2.00.1403291125140.2734@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please full a Ceph RBD fix from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This drops a bad assert that a few users have been hitting but we've only 
recently been able to track down.

Thanks!
sage



----------------------------------------------------------------
Alex Elder (1):
      rbd: drop an unsafe assertion

 drivers/block/rbd.c |    1 -
 1 file changed, 1 deletion(-)
