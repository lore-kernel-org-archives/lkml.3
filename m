Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaFWTEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:04:04 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:46285 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaFWTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:03:58 -0400
Message-Id: <20140623185431.396309193@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jun 2014 22:54:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: [patch 0/4] timerfd c/r support, v4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, here is an updated version of c/r support for timerfd files. The main change
is in how @ticks are restored in patch 3 -- I switched to ioctl code, which is wrapped
with CONFIG because I still think that while there is only one ioctl designated
solely for c/r needs no need to build it all the time until explicitly requested.
Please take a look once time permit. Comments are highly appreciated.
Also note the last patch is for man-page git repo, not for kernel.

Thanks!
