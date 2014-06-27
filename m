Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaF0NRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:17:15 -0400
Received: from mail001.aei.ca ([206.123.6.130]:48997 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790AbaF0NRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:17:13 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [PANIC] at drivers/drm/drm_irq.c:976 with 3.16-rc2+git
Date: Fri, 27 Jun 2014 09:17:08 -0400
Message-ID: <1932549.XoogLcbv2o@grover>
Organization: me
User-Agent: KMail/4.13.2 (Linux/3.16.0-1-git; KDE/4.13.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Got the following panic runing 16-rc2 + git.  The latest commit was:

commit d91d66e88ea95b6dd21958834414009614385153
Merge: 07f4695 6663a4f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jun 25 05:44:17 2014 -0700

I was not doing anything interesting (displaying a photo from facebook with firefox) 
when this happened.  The distribution is arch at is up to date as of june 26th.

Thanks
Ed Tomlinson
