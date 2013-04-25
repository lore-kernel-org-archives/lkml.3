Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3DYXuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:50:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab3DYXuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:50:15 -0400
Date: Thu, 25 Apr 2013 20:50:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.9-final] media fixes
Message-ID: <20130425205004.3e5abd5d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For two driver fixes. One avoids reading any file at a system with a
cx25821 board (fortunately, this is not a common device). The other one
prevents reading after a buffer with ISDB-T devices based on mb86a20s.

Regards,
Mauro

-

The following changes since commit 35ccecef6ed48a5602755ddf580c45a026a1dc05:

  [media] [REGRESSION] bt8xx: Fix too large height in cropcap (2013-03-26 08:37:00 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to c95789ecd5a979fd718ae09763df3fa50dd97a91:

  [media] cx25821: do not expose broken video output streams (2013-04-15 08:28:41 -0300)

----------------------------------------------------------------
Hans Verkuil (1):
      [media] cx25821: do not expose broken video output streams

Mauro Carvalho Chehab (1):
      [media] mb86a20s: Fix estimate_rate setting

 drivers/media/dvb-frontends/mb86a20s.c    | 2 +-
 drivers/media/pci/cx25821/cx25821-video.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

