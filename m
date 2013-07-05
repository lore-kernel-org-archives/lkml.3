Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3GETMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:12:06 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52499 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3GETMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <1373036223.2711.62.camel@sauron.fi.intel.com>
References: <1373036223.2711.62.camel@sauron.fi.intel.com>
Date: Fri, 5 Jul 2013 12:12:03 -0700
X-Google-Sender-Auth: _3u9_f0cLSDl_raHXZ0TQHl1KJk
Message-ID: <CA+55aFxv2A+4mfhuBUVJnPhDzvLw3ttg6BV3=FPDwRqGTfc2Xg@mail.gmail.com>
Subject: Re: [GIT PULL] UBI changes for 3.11-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 5, 2013 at 7:57 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>
>  drivers/mtd/ubi/build.c     | 59 ++++++++++++++++++++++++++++++++++++++++-------------------
>  drivers/mtd/ubi/fastmap.c   |  4 +++-
>  include/uapi/mtd/ubi-user.h |  5 ++++-

That's a very strange script you're using. It has somehow cut off the
last line of the diffstat - the one that actually is the primary one
to check the overally statistics:

 3 files changed, 47 insertions(+), 21 deletions(-)

Please double-check your pull script.

Anyway, pulled, so you don't need to re-send, but please fix this for
future pulls.

                Linus
