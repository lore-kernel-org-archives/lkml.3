Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab3GOHwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:52:08 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57925 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3GOHwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 15 Jul 2013 13:21:26 +0530
Message-ID: <CALkWK0=-Mu01T7dT0X51-2VHKpa0p9w4N+dbdUUGQAbxvfeCJw@mail.gmail.com>
Subject: Re: [PATCH 0/7] Minor perf completion improvements
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

Does this series look alright?

On Thu, Jul 4, 2013 at 6:11 PM, Ramkumar Ramachandra <artagnon@gmail.com> wrote:
> Hi,
>
> So I just started using perf, and noticed the accompanying completion
> script. Having dabbled with git.git's completion script a bit, I
> thought I should contribute what I learnt from it.
>
> [6/7] is the meat of the series, and the preceding patches work
> towards the same goal: to strip dependency on the bash-completion
> package.
>
> Thanks.
>
> Ramkumar Ramachandra (7):
>   perf completion: don't dictate perf install location
>   perf completion: update __ltrim_colon_completions
>   perf completion: strip dependency on _filedir
>   perf completion: modernize style
>   perf completion: strip function_exists ()
>   perf completion: strip dependency on bash-completion
>   perf completion: use more comp words
>
>  tools/perf/bash_completion | 110 +++++++++++++++++++++++++++++++++++----------
>  1 file changed, 87 insertions(+), 23 deletions(-)
>
> --
> 1.8.3.1.643.gebeea52.dirty
>
