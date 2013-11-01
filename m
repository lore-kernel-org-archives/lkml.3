Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3KAPli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:41:38 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:41899 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3KAPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:41:36 -0400
Date: Fri, 1 Nov 2013 16:41:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf version not set when building out of tree
Message-ID: <20131101154133.GA8659@gmail.com>
References: <5272E86B.7090003@gmail.com>
 <20131101070219.GA21471@gmail.com>
 <5273AD00.1050002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5273AD00.1050002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 11/1/13, 1:02 AM, Ingo Molnar wrote:
> >
> >* David Ahern <dsahern@gmail.com> wrote:
> >
> >>When building out of tree:
> >>
> >>make perf-tar-src-pkg
> >
> >What's the canonical way to build a perf tarball? I didn't find any
> >makefile target for that.
> 
> Perhaps I misunderstand your question. From the top-level of a kernel tree:
> $ make help | grep perf
> 
>   perf-tar-src-pkg    - Build perf-3.12.0-rc5.tar source tarball
>   perf-targz-src-pkg  - Build perf-3.12.0-rc5.tar.gz source tarball
>   perf-tarbz2-src-pkg - Build perf-3.12.0-rc5.tar.bz2 source tarball
>   perf-tarxz-src-pkg  - Build perf-3.12.0-rc5.tar.xz source tarball

Thx - I was trying to find that within the tools/perf/ Makefiles ;-)

Thanks,

	Ingo
