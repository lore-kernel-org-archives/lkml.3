Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab3BEPfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:35:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab3BEPf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:35:28 -0500
Date: Tue, 5 Feb 2013 13:35:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.7-rc7] media fixes
Message-ID: <20130205133519.51713e27@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a regression fix on a few radio drivers that were preventing radio TX
to work on those devices.

Regards,
Mauro

-

The following changes since commit 68d6f84ba0c47e658beff3a4bf0c43acee4b4690:

  [media] uvcvideo: Set error_idx properly for S_EXT_CTRLS failures (2013-01-11 13:30:27 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to ce4a3d52888a95473914bd54bcf6c566014fc03e:

  [media] radio: set vfl_dir correctly to fix modulator regression (2013-01-24 18:54:14 -0200)

----------------------------------------------------------------
Hans Verkuil (1):
      [media] radio: set vfl_dir correctly to fix modulator regression

 drivers/media/radio/radio-keene.c       |  1 +
 drivers/media/radio/radio-si4713.c      |  1 +
 drivers/media/radio/radio-wl1273.c      |  1 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 10 ++++++++++
 4 files changed, 13 insertions(+)

