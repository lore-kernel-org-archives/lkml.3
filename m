Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHDGaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:30:39 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37086 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaHDGah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140804162633.2d2e8604@canb.auug.org.au>
References: <20140804162633.2d2e8604@canb.auug.org.au>
Date: Sun, 3 Aug 2014 23:30:35 -0700
Message-ID: <CAMEtUuxgmUB=MLMjLBpjmb7nQ6nPE2spkmgFVoXDu5Fq6cFYyw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the security tree with the net-next tree
From: Alexei Starovoitov <ast@plumgrid.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2014 at 11:26 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi James,
>
> Today's linux-next merge of the security tree got a conflict in
> kernel/seccomp.c between commit 7ae457c1e5b4 ("net: filter: split
> 'struct sk_filter' into socket and bpf parts") from the net-next tree
> and commits c8bee430dc52 ("seccomp: split filter prep from check and
> apply") and 3ba2530cc06e ("seccomp: allow mode setting across threads")
> from the security tree.
>
> I fixed it up (I hope - see below) and can carry the fix as necessary
> (no action is required).

Looks correct. Thanks.
Will double check during merge window.
