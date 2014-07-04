Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaGDA4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 20:56:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbaGDA4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 20:56:50 -0400
Date: Thu, 3 Jul 2014 18:01:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.16-rc4
Message-ID: <20140704010107.GA21102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.16-rc4

for you to fetch changes up to 6b64168de843b16e96a22f9e98c6afc92ee1da71:

  Merge tag 'iio-fixes-for-3.16b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2014-06-29 09:43:23 -0700)

----------------------------------------------------------------
Staging driver bugfixes for 3.16-rc4

Nothing major here, just 4 small bugfixes that resolve some issues
reported for the IIO (staging and non-staging) and the tidspbridge
driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Adam Thomson (1):
      iio: of_iio_channel_get_by_name() returns non-null pointers for error legs

Dan Carpenter (1):
      staging: iio/ad7291: fix error code in ad7291_probe()

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.16b' of git://git.kernel.org/.../jic23/iio into staging-linus

Peter Meerwald (1):
      iio:adc:ad799x: Fix reading and writing of event values, apply shift

Suman Anna (1):
      staging: tidspbridge: fix an erroneous removal of parentheses

 drivers/iio/adc/ad799x.c                      | 8 ++++++--
 drivers/iio/inkern.c                          | 6 ++++--
 drivers/staging/iio/adc/ad7291.c              | 4 ++--
 drivers/staging/tidspbridge/core/tiomap3430.c | 6 ++++--
 4 files changed, 16 insertions(+), 8 deletions(-)
