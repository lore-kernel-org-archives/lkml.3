Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3I3HU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:20:26 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:64295 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3I3HUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:20:23 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 30 Sep 2013 09:20:20 +0200
Message-ID: <CA+icZUUOfFdd34CZfGpX+_ezuaPyeakZSGGvfmw8K1cguUbmxg@mail.gmail.com>
Subject: fuse-3.12-fixes?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Maxim Patlasov <MPatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

any reasons why these fuse-3.12-fixes did not went into -rc3?

fuse: fix fallocate vs. ftruncate rac
fuse: wait for writeback in fuse_file_fallocate()

Thanks.

Regards,
- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/mszeredi/fuse.git/log/?h=for-linus
