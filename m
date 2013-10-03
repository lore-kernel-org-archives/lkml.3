Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3JCHVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:21:10 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54509 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3JCHU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:20:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131003062505.GE25345@gmail.com>
References: <CALkWK0mmUZe-Wv2H2Z3y9FN0_kYv9gKaaXkMQ0UD-J9Q+=wFzQ@mail.gmail.com>
 <524C1964.8090205@gmail.com> <CALkWK0kzXnBKiRyN5HPE-_nScOG-JKjAnD1ujxA_R8tWQWrxZQ@mail.gmail.com>
 <20131003062505.GE25345@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 3 Oct 2013 12:50:16 +0530
Message-ID: <CALkWK0ku=fFpQkd6r6DhwVAALpfgA8K-JkTjLJqSf0y-ysmmkQ@mail.gmail.com>
Subject: Re: [QUERY] Why does perf-trace need me to be root?
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>    echo 'kernel.perf_event_paranoid = -1' >> /etc/sysctl.conf

Thanks Ingo. It's called /etc/sysctl.d/* now:
https://www.archlinux.org/news/deprecation-of-etcsysctlconf/

> The current output:
>
>   comet:~/tip> perf trace
>   Couldn't read the raw_syscalls tracepoints information!
>
> is as hostile to the user as it gets ;-)

Patches are on the way :)
