Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbaLLF2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:28:10 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:54197 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760014AbaLLF2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:28:08 -0500
MIME-Version: 1.0
Date: Fri, 12 Dec 2014 15:28:06 +1000
Message-ID: <CAPM=9tw6DmAU0rwPzTO=yPt5s6xLMTP=VuyPR7ObtkFNquf5HA@mail.gmail.com>
Subject: drm pull waiting on other trees
From: Dave Airlie <airlied@gmail.com>
To: Joerg Roedel <jroedel@suse.de>, Simon Horman <horms@verge.net.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Simon, Joerg,

I've got merges from you guys in my tree that don't seem to be in
Linus's tree yet, I'm a bit concerned as the drm merge is a large one
and I'd like to have it in Linus' tree ASAP.

The rockchip iommu and bunch of shmobile/rcar changes are what I
believe is currently stopping me.

Dave.
