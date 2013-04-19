Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030865Ab3DSPPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:15:19 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41553 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030656Ab3DSPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:15:11 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
Date: Fri, 19 Apr 2013 17:15:10 +0200
Message-ID: <CAJfpeguWUqaRwd4FgoZyJ0Se6i-_J06vcCKkWCa5q_+DDMncog@mail.gmail.com>
Subject: [GIT PULL] fuse build fix for 3.9
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull this single fix from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This fixes android builds.  The patch appears large, but is just
search & replace.

Thanks,
Miklos
----

Miklos Szeredi (1):
      fuse: fix type definitions in uapi header

---
 include/uapi/linux/fuse.h |  436 ++++++++++++++++++++++-----------------------
