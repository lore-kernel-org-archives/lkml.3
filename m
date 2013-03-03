Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3CCLe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 06:34:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33023 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3CCLe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 06:34:26 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 3 Mar 2013 12:34:24 +0100
Message-ID: <CA+icZUUWqeHdgjP-Hi630DDwO65evWUUCX2tBYfj=Cn1w3dEAg@mail.gmail.com>
Subject: [git.k.o] gitweb->cgit: Re-add Git snapshot tarball feature
From: Sedat Dilek <sedat.dilek@gmail.com>
To: webmaster@kernel.org
Cc: Konstantin Ryabitsev <mricon@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

unfortunately, the Git snapshot tarball feature was dropped when
switching from gitweb->cgit interface.

For example the Freetz router project extracted the Kbuild-system out
of Linux-kernel sources.
This is no more possible (see old version [2] and new one in [3]).
Freetz introduced "git_archive" checkout method [3] to fix it.

Can you please re-add?
For an example see [4] and [5].

Thanks in advance.

Regards,
- Sedat -

[1] http://freetz.org/browser/trunk/tools/make/kconfig.mk?rev=9895
[2] http://freetz.org/browser/trunk/tools/make/kconfig.mk?rev=10216
[3] http://freetz.org/changeset/10215/trunk
[4] http://cgit.freedesktop.org/mesa/drm/commit/?id=41fc2cc8a98a8d02ea7d3635d3103f7dd371de10
[5] http://cgit.freedesktop.org/mesa/drm/snapshot/drm-41fc2cc8a98a8d02ea7d3635d3103f7dd371de10.tar.gz
