Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3I3Re3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:34:29 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:40441 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3I3Re2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130930171220.GC10293@ghostprotocols.net>
References: <20130912133855.GA23780@gmail.com>
	<CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
	<CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
	<20130912184341.GA11400@ghostprotocols.net>
	<52321CE4.1080804@gmail.com>
	<20130912200236.GC11400@ghostprotocols.net>
	<20130912203116.GD32644@gmail.com>
	<20130912204313.GA3259@gmail.com>
	<20130915091029.GA21465@gmail.com>
	<20130930164210.GA22342@gmail.com>
	<20130930171220.GC10293@ghostprotocols.net>
Date: Mon, 30 Sep 2013 10:34:27 -0700
X-Google-Sender-Auth: 1hJWq9l-chcqVUhOaZ8_Ll_AyzE
Message-ID: <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them in parallel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 10:12 AM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
>
> Checking why that strlcpy failed...

I don't think glibc does strlcpy. It's not a standard C function, and
it's somewhat controversial (although I dislike strncpy more with the
crazy zero-padding, ugh).

            Linus
