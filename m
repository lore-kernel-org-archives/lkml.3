Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3JNHYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:24:52 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58416 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3JNHYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:24:51 -0400
MIME-Version: 1.0
Date: Mon, 14 Oct 2013 10:24:49 +0300
X-Google-Sender-Auth: QSLJUthUHaq0h1l5BTI0pjaPQaE
Message-ID: <CAOJsxLGHU5mxZAAZ2MuoV3rVwP-5E=viSmeF7P=ZgmpxRRKmFA@mail.gmail.com>
Subject: [GIT PULL] SLAB fix for v3.12-rc5
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

It has a regression fix for overly eager slab cache name checks.

                        Pekka

------------------>
The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

for you to fetch changes up to 3e374919b314f20e2a04f641ebc1093d758f66a4:

  slab_common: Do not check for duplicate slab names (2013-09-28 09:47:41 +0300)

----------------------------------------------------------------
Christoph Lameter (1):
      slab_common: Do not check for duplicate slab names

 mm/slab_common.c | 2 ++
 1 file changed, 2 insertions(+)
~
