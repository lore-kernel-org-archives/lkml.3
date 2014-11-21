Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbaKUKua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:50:30 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:56057 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbaKUKu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:50:26 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <CA+icZUVSdSDqUCf3+2SmGx4DfhKvxPi4ivvhNzTEnbe1j4eFQA@mail.gmail.com>
References: <20141120164531.GB3596@tucsk>
	<CA+icZUVSdSDqUCf3+2SmGx4DfhKvxPi4ivvhNzTEnbe1j4eFQA@mail.gmail.com>
Date: Fri, 21 Nov 2014 11:50:24 +0100
Message-ID: <CAJfpegs6iF+O9W40k+L=kmydZA7O20H6aYdwtTF1vEsq4790xw@mail.gmail.com>
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
From: Miklos Szeredi <miklos@szeredi.hu>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:43 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-current
>>
>
> This seems to be the place where overlayfs-fixes are collected for a
> git-pull request.
> Can you add a "T:" line with the Git tree into MAINTAINERS file if
> this is the case?

Done that already.  See "ovl: update MAINTAINERS" patch in that series.

Thanks,
Miklos
