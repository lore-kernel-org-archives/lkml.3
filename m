Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3CCMvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:51:44 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43015 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3CCMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:51:43 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 3 Mar 2013 13:51:42 +0100
Message-ID: <CA+icZUXfREDxtvoZTJEhCOMJWtYVwzNm3m1REQXtyDeQ8bh4Uw@mail.gmail.com>
Subject: Re: [git.k.o] Add git archive $remote-repository support?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: webmaster@kernel.org
Cc: Konstantin Ryabitsev <mricon@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( More background infos see [1]. )

Here as an example to extract kbuild-system from $repository:

repository="git://repo.or.cz/linux-2.6.git"

paths="scripts/basic,scripts/kconfig,scripts/Kbuild.include,scripts/Makefile.build,scripts/Makefile.host,scripts/Makefile.lib"

version="v3.8"

$ git archive --verbose --format=tar --remote="$repository"
--prefix="kbuild-$version/" $version $paths | tar -xv

NOTE: <git://repo.or.cz/linux-2.6.git> supports remote-git-archive support.

Can you implement this?

- Sedat -

[1] http://marc.info/?l=linux-kernel&m=136231049311175&w=2
