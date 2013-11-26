Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3KZUXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:23:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:47608 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752655Ab3KZUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:23:38 -0500
Date: Tue, 26 Nov 2013 15:23:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH] ima: Fix build failure of redefinition of
 integrity_init_keyring()
Message-ID: <20131126152336.124408c0@gandalf.local.home>
In-Reply-To: <CA+55aFzSYFMktYLBk6q+5uTS7SS5ufz3ofyZ4ZWcn4r-qSDgGA@mail.gmail.com>
References: <20131126150415.2ecdb563@gandalf.local.home>
	<CA+55aFzSYFMktYLBk6q+5uTS7SS5ufz3ofyZ4ZWcn4r-qSDgGA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013 12:12:12 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Nov 26, 2013 at 12:04 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > If CONFIG_INTEGRITY_SIGNATURE is set, but
> > CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not, then we get the following
> > build failure:
> 
> Didn't this already get fixed by the reverts I did and Mimi acked?
> 
> Commits 4c1cc40a2d49 ("Revert "KEYS: verify a certificate is signed by
> a 'trusted' key"") and 34ef7bd3823b ("Revert "ima: define '_ima' as a
> builtin 'trusted' keyring"") to be exact.
> 

Ah, your right. I was working against 3.13-rc1, that revert came later.

OK, please ignore.

I'll add those reverts to my tests for my branches that are still based
on 3.13-rc1.

Thanks!

-- Steve
