Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3HFKbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:31:55 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:48554 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3HFKbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:31:53 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-02-5200d0987621
Date: Tue, 06 Aug 2013 07:31:47 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.11-rc5] media fixes
Message-id: <20130806073147.496203fd@samsung.com>
In-reply-to: <20130805165354.74b01685@samsung.com>
References: <20130805165354.74b01685@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t/hQN0ZFxiCDJbuUbSYs34Nm8XlXXPY
	LHo2bGW1eNT3lt2BxePEjN8sHp83yQUwRXHZpKTmZJalFunbJXBl3JnRz1jQJ1FxrOUnYwPj
	J6EuRk4OCQETid6Jl5ghbDGJC/fWs3UxcnEICSxhlNh8/TQ7hNPDJDHl1iuwKhYBVYkP744z
	gthsAkYSrxpbWEFsESD784srrCANzAKLGSU+Pl/PDpIQFjCUuLvxLxOIzQtkf9t6AGwQJ1DD
	3annwAYJAcX/rvrM0sXIAXSGk8TWqb4Q5YISPybfYwGxmQW0JDZva2KFsOUlNq95yzyBUWAW
	krJZSMpmISlbwMi8ilG0tDi5oDgpPddIrzgxt7g0L10vOT93EyMkVIt3ML7YYHWIUYCDUYmH
	N+Hq/0Ah1sSy4srcQ4wSHMxKIrwqOxmChHhTEiurUovy44tKc1KLDzEycXBKNTCutvj79sl2
	/kurejyfmcpca869K7jl3zbTtMhdsSfy9e9I3Nj96EhZFJ9IXu3dquS0aLe1R5tWiK+Oe7Hl
	079drC3+y3WvnEi5fWkPx+RsTo7fYVJ6hUtWHxHtc9etY78r8unH7F1FTxMPiKh+2jtF/um2
	X0qS0Wf8wjk2R075lfRqY0TSjWX9SizFGYmGWsxFxYkAl8epSzMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 5 Aug 2013 16:53:54 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Hi Linus,
> 
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> 
> for some drivers fixes (em28xx, coda, usbtv, s5p, hdpvr and ml86v7667) and 
> at a fix for media DocBook.
> 
> Thanks!
> Mauro
> 
> -
> 
> The following changes since commit 1b2c14b44adcb7836528640bfdc40bf7499d987d:
> 
Gah! It seems that my emailer replaced everything below this line by the
content of .signature when clicked at the combo-box to switch to use my email
at Samsung[1]. Sorry for that.

[1] maybe as a side-effect of this bug: https://bugs.freedesktop.org/show_bug.cgi?id=66515

Anyway, let me redo the pull request below.

Thanks,
Mauro

-

Hi Linus,
 
Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for some drivers fixes (em28xx, coda, usbtv, s5p, hdpvr and ml86v7667) and 
at a fix for media DocBook.

-

The following changes since commit 1b2c14b44adcb7836528640bfdc40bf7499d987d:

  MAINTAINERS & ABI: Update to point to my new email (2013-07-08 11:04:11 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to f813b5775b471b656382ae8f087bb34dc894261f:

  [media] em28xx: fix assignment of the eeprom data (2013-07-26 12:28:03 -0300)

----------------------------------------------------------------
Alban Browaeys (1):
      [media] em28xx: fix assignment of the eeprom data

Alexander Shiyan (1):
      [media] media: coda: Fix DT driver data pointer for i.MX27

Alexey Khoroshilov (1):
      [media] hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Andrzej Hajda (2):
      [media] DocBook: upgrade media_api DocBook version to 4.2
      [media] v4l2: added missing mutex.h include to v4l2-ctrls.h

Hans Verkuil (2):
      [media] ml86v7667: fix compile warning: 'ret' set but not used
      [media] usbtv: fix dependency

John Sheu (1):
      [media] s5p-mfc: Fix input/output format reporting

Lubomir Rintel (2):
      [media] usbtv: Fix deinterlacing
      [media] usbtv: Throw corrupted frames away

Sachin Kamat (1):
      [media] s5p-g2d: Fix registration failure

 Documentation/DocBook/media_api.tmpl         |  4 +-
 drivers/media/i2c/ml86v7667.c                |  4 +-
 drivers/media/platform/coda.c                |  2 +-
 drivers/media/platform/s5p-g2d/g2d.c         |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 79 +++++++++++-----------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 46 ++++++----------
 drivers/media/usb/em28xx/em28xx-i2c.c        |  2 +-
 drivers/media/usb/hdpvr/hdpvr-core.c         | 11 ++--
 drivers/media/usb/usbtv/Kconfig              |  2 +-
 drivers/media/usb/usbtv/usbtv.c              | 51 +++++++++++++-----
 include/media/v4l2-ctrls.h                   |  1 +
 11 files changed, 101 insertions(+), 102 deletions(-)

