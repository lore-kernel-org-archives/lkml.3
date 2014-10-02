Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaJBVK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:10:57 -0400
Received: from lists.s-osg.org ([54.187.51.154]:39126 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbaJBVK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:10:56 -0400
Date: Thu, 2 Oct 2014 18:10:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.17] media fixes
Message-ID: <20141002181050.2791714d@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.17-rc8

For one last time regression fix at em28xx. The removal of .reset_resume
broke suspend/resume on this driver for some devices.

There are more fixes to be done for em28xx suspend/resume to be better
handled, but I'm opting to let them to stay for a while at the media devel
tree, in order to get more tests. So, for now, let's just revert this patch.

Thanks!
Mauro

The following changes since commit 8e2c8717c1812628b5538c05250057b37c66fdbe:

  [media] em28xx-v4l: get rid of field "users" in struct em28xx_v4l2" (2014-09-21 21:27:57 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.17-rc8

for you to fetch changes up to 90a5dbef1a66e9f55b76ccb83c0ef27c0bd87c27:

  Revert "[media] media: em28xx - remove reset_resume interface" (2014-09-28 22:25:24 -0300)

----------------------------------------------------------------
media fixes for v3.17-rc8

----------------------------------------------------------------
Mauro Carvalho Chehab (1):
      Revert "[media] media: em28xx - remove reset_resume interface"

 drivers/media/usb/em28xx/em28xx-cards.c | 1 +
 1 file changed, 1 insertion(+)

