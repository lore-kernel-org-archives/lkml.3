Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab3DZPnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:43:45 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:47768 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3DZPnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:43:43 -0400
Message-ID: <1366991021.8964.221.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support
 BPF_S_ANC_SECCOMP_LD_W instruction
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Apr 2013 08:43:41 -0700
In-Reply-To: <CAKU6vybrYK9oimKSEGhoLeNzhtk=7r3zouRgzDFqGwJHd=psGQ@mail.gmail.com>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
	 <1366962706-24204-3-git-send-email-xi.wang@gmail.com>
	 <1366985926.8964.190.camel@edumazet-glaptop>
	 <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com>
	 <1366989094.8964.212.camel@edumazet-glaptop>
	 <CAKU6vybrYK9oimKSEGhoLeNzhtk=7r3zouRgzDFqGwJHd=psGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 11:29 -0400, Xi Wang wrote:
> On Fri, Apr 26, 2013 at 11:11 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > 2) Calling a function potentially destroys some registers.
> >    %rdi,%r8,%r9 for instance, so we are going to crash very easily.
> >
> > I dont know, I feel a bit uncomfortable having to explain this to
> > someone sending security related patches...
> 
> My old code did save these registers.  But, do we really need that for
> seccomp?  For example, %rdi (skb) is always NULL and never used by
> seccomp filters.  Did I miss anything?

I do not know.

This is not explained in your changelog or in any comment.

You have to make the full analysis yourself and make us comfortable with
the results.

You send patches and ask us to spend hours on it, this is not how it
works.



