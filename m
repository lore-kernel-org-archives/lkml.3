Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3JBN0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:26:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35300 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3JBN0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:26:35 -0400
Date: Wed, 2 Oct 2013 15:26:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [BUG] perf timechart segfault
Message-ID: <20131002132631.GC27811@gmail.com>
References: <CALkWK0k5sQ9WCGevFQ3D18=Fs3ziS8imVVvasE0QR9e0r91cYA@mail.gmail.com>
 <20131002111958.GC10099@krava.brq.redhat.com>
 <CALkWK0mCbnBZXJNFyX3odoGb1pvGs7ox1mOiFacqX98ewBOGKw@mail.gmail.com>
 <20131002115935.GD10099@krava.brq.redhat.com>
 <CALkWK0ny7MT=5uWykERjKrAe5Odpq72gsFneQB6z1jNHYu6xsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0ny7MT=5uWykERjKrAe5Odpq72gsFneQB6z1jNHYu6xsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> Jiri Olsa wrote:
> > looks like you're missing this one:
> > (git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core)
> 
> Very messy; doesn't rebase on top of the latest torvalds/linux.git 
> cleanly: I get a merge conflict at patch 9 of 74. Since my work is based 
> on torvalds/linux.git, I was hoping to rebase it on top of Arnaldo's 
> tree, but that results in conflicts too: I'm resolving them now.
> 
> Are the merge windows always this large? Why isn't Arnaldo's tree listed 
> in MAINTAINERS?

note that it's Arnaldo's development tree, not a tree to generally base 
pull requests on - that is what tip:perf/core is for.

Thanks,

	Ingo
