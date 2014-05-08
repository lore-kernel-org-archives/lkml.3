Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaEHXND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 19:13:03 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:44628 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbaEHXNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 19:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140508211217.GC26353@dastard>
References: <20140508211217.GC26353@dastard>
Date: Thu, 8 May 2014 16:13:00 -0700
X-Google-Sender-Auth: W8ZLQuKCVYwjMGpzk2_6Ljoz8DM
Message-ID: <CA+55aFy9B=OcqfniMiq+EhDa_rzc0-owcmbUck1FmBOU+Q-Dvw@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: fixes for 3.15-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 2:12 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> BTW, will GPG signing these pull requests cause you problems?

Nope. But I won't be checking email signatures. GPG email signing is
so badly done that afaik only one or two email clients support it.

> I've
> been signing everything "official" I send as the XFS maintainer
> (e.g. notifications of tree updates) and I figured that pull
> requests are about as "official" as it gets. The tag is signed, so
> I'm not particularly worried either way...

.. what tag? You point me at

>   git://oss.sgi.com/xfs/xfs.git xfs-fixes-for-3.15-rc5

and that is definitely not a tag.

Did you *mean* to point me at refs/tags/xfs-for-linus-3.15-rc5, perhaps?

I've not pulled due to the ambiguity of the pull request.

           Linus
