Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaDRCKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:10:50 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42188 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRCKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:10:46 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [ANNOUNCE] backports-3.15-rc1 is released
Date: Thu, 17 Apr 2014 19:10:39 -0700
Message-Id: <1397787039-17821-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux backports [0] backports-v3.15-rc1 is out [1]. Please
go test and see if you can and break things or if see if
we've broken anything so far before a final release in
sync with Linus' releases. As usual development only happens
on the master branch, we'll then carry fixes onto the stable
branch. It just so happens that today's master branch is
exactly as we have it on the linux-3.15.y branch.

[0] https://backports.wiki.kernel.org/
[1] https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.15-rc1/backports-3.15-rc1-1.tar.xz

  Luis
