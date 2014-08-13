Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaHMSA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:00:28 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:57976 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaHMSA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:00:26 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVDJHOu7AFZqeGppxXykRhdG8qwwifpXcXVVr=argwoiQ@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<063D6719AE5E284EB5DD2968C1650D6D174760F3@AcuExch.aculab.com>
	<CAMEtUuyULyzVb1nkJn_Tj_aKjokcBQaw_EnWBdDvtvf9iV7uXA@mail.gmail.com>
	<CALCETrVDJHOu7AFZqeGppxXykRhdG8qwwifpXcXVVr=argwoiQ@mail.gmail.com>
Date: Wed, 13 Aug 2014 11:00:24 -0700
Message-ID: <CAMEtUuxxEvQWHKTrTDazd3RaeYC1_-_CvAyL+GFpMVDKBPi32A@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 00/26] BPF syscall, maps, verifier,
 samples, llvm
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Laight <David.Laight@aculab.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:40 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> But don't you need some kind of detection anyway to handle the case
> where something jumps to the middle of the "load 64-bit immediate"?  I

added few test cases to test_verifier to see that this case is caught
and it looks ok, but you got me worried. May be few more checks needed.
Thanks!
