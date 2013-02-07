Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3BGBRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:17:03 -0500
Received: from ozlabs.org ([203.10.76.45]:35728 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab3BGBRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:17:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: <torvalds@linux-foundation.org>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PULL] virtio fix
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
CC: "LKML" <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
Date: Thu, 07 Feb 2013 11:43:53 +1030
Message-ID: <87zjzhhqni.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a9284153d965a57edc7162a8e57c14c97f3a935:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-01-20 20:55:49 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to aded024a12b32fc1ed9a80639681daae2d07ec25:

  virtio_console: Don't access uninitialized data. (2013-02-07 11:37:37 +1030)

----------------------------------------------------------------
Obviously I forgot to push this before linux.conf.au...

Thanks,
Rusty.

----------------------------------------------------------------
Sjur Brændeland (1):
      virtio_console: Don't access uninitialized data.

 drivers/char/virtio_console.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

