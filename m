Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902AbaH0TSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:18:13 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38871 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935182AbaH0TSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:18:07 -0400
Date: Wed, 27 Aug 2014 12:18:01 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chema Gonzalez <chema@google.com>, Namhyung Kim <namhyung@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RFC v7 net-next 00/28] BPF syscall
Message-ID: <20140827121801.3bfd916e@urahara>
In-Reply-To: <CALCETrXAfZJTsF2nPFw55rHkfbNXKQuF8Frnq3e1wHEoGxLM4w@mail.gmail.com>
References: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
	<CALCETrX2MzNxQ1ogt+Qx8iPjUe+z0gN6ZLwu9nAcZzTN+D+iYw@mail.gmail.com>
	<CAMEtUuwYqJVUuZxPBKy57NonWF+X_5vkNx4uSEx_d=-xBka1Kg@mail.gmail.com>
	<CALCETrWs9GRufGKxAoV628bh1f3HObkxNQuW3tYRt2rFwNAbxA@mail.gmail.com>
	<CAMEtUuw1n1HzAeyKFj9=nGq7RKZq7TADS-6M_BkHbTsWJ_Gm-Q@mail.gmail.com>
	<CALCETrXAfZJTsF2nPFw55rHkfbNXKQuF8Frnq3e1wHEoGxLM4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something in man page format similar to FreeBSD man page:
 http://www.freebsd.org/cgi/man.cgi?bpf(4)

would be more readable and reviewable.
