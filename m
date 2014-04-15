Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaDOWwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:52:45 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:34945 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaDOWwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:52:43 -0400
MIME-Version: 1.0
In-Reply-To: <1397502179-15029-1-git-send-email-dborkman@redhat.com>
References: <1397502179-15029-1-git-send-email-dborkman@redhat.com>
Date: Tue, 15 Apr 2014 15:52:42 -0700
X-Google-Sender-Auth: b4GVEmQg1aITR3Gx7VwGhM9baz8
Message-ID: <CA+55aFy2hDuadQK=09JiEL9wxLD4OLiODiSzhsydwfP9jkFMpQ@mail.gmail.com>
Subject: Re: [PATCH] seccomp: fix populating a0-a5 syscall args in 32-bit x86 BPF
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry for delayed testing, I just came back home and didn't have
access to the affected 32-bit machine on the road ]

On Mon, Apr 14, 2014 at 12:02 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
> Linus reports that on 32-bit x86 Chromium throws the following seccomp
> resp. audit log messages:

Tested, and fixes the problem for me.

Thanks,

              Linus
