Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbbAGIZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:25:00 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57243 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbbAGIY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:24:58 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 7 Jan 2015 09:24:57 +0100
Message-ID: <CA+icZUVVPe68VGwRcc5ztxGwHi83wHJVeiJMUuBynm2LypoaZA@mail.gmail.com>
Subject: Missing next-$date git-tag when pulled-in linux-next.git on top of linus.git
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My workflow looks like this

# Get mainline Git tree
$ git clone $LINUS_GIT_URL

# Checkout latest mainline (rc) tag (aka -next's "origin" commit-id)
$ git checkout -b Linux-v3.19-rc3 v3.19-rc3

# Base to pull in current -next
$ git checkout -b Linux-next-20150107

# Pull in stuff from next-20150107
$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
tags/next-20150107

Unfortunately, this is not getting the git-tag "next-20150107" which I fix by...

$ git tag next-20150107

Do you happen to know how to do that more elegant?

( I wanted to avoid to run... git pull $git_url --tags ... which gets
all -next tags. )

Thanks.

- Sedat -
