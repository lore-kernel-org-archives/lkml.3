Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbbAGJGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:06:34 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60257 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbAGJG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:06:27 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 7 Jan 2015 10:06:25 +0100
Message-ID: <CA+icZUVM6gXZZztku3z2iy78Z-qMULt0qFsbEQva0hWQ5gKUyQ@mail.gmail.com>
Subject: Re: [PATCH 3.18 00/84] 3.18.2-stable review
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ From the original posting in [1] ]
Hi Greg,

just testing Linux v3.18.2-rc1.

I am here in my local Git tree and applying not the big tarball but
from the stable-queu.git tree.

$ cd linux-git

$ for i in $( cat ../stable-queue-git/queue-3.18/series ) ; do echo [
$i ] ;  git am ../stable-queue-git/queue-3.18/${i} ; done

Unfortunately, there is missing a patch to bump the version in the Makefile.

Is there something speaking against to put your changes to Makefile as
a patch into queue-3.18?

>From your original posting in [1]
...
-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.18.2-rc1

Filipe Manana <fdmanana@suse.com>
...

For me this means to do an extra commit, add tags etc.

Thanks.

Regards,
- Sedat -


[1] http://marc.info/?l=linux-kernel&m=142060001512442&w=2
