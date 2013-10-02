Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3JBNLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:11:10 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33989 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3JBNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131002115935.GD10099@krava.brq.redhat.com>
References: <CALkWK0k5sQ9WCGevFQ3D18=Fs3ziS8imVVvasE0QR9e0r91cYA@mail.gmail.com>
 <20131002111958.GC10099@krava.brq.redhat.com> <CALkWK0mCbnBZXJNFyX3odoGb1pvGs7ox1mOiFacqX98ewBOGKw@mail.gmail.com>
 <20131002115935.GD10099@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 2 Oct 2013 18:40:26 +0530
Message-ID: <CALkWK0ny7MT=5uWykERjKrAe5Odpq72gsFneQB6z1jNHYu6xsw@mail.gmail.com>
Subject: Re: [BUG] perf timechart segfault
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> looks like you're missing this one:
> (git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core)

Very messy; doesn't rebase on top of the latest torvalds/linux.git
cleanly: I get a merge conflict at patch 9 of 74. Since my work is
based on torvalds/linux.git, I was hoping to rebase it on top of
Arnaldo's tree, but that results in conflicts too: I'm resolving them
now.

Are the merge windows always this large? Why isn't Arnaldo's tree
listed in MAINTAINERS?
