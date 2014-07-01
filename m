Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbaGARr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:47:58 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:36559 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbaGARr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:47:56 -0400
MIME-Version: 1.0
In-Reply-To: <1404211489-9848-1-git-send-email-pbonzini@redhat.com>
References: <1404211489-9848-1-git-send-email-pbonzini@redhat.com>
Date: Tue, 1 Jul 2014 10:47:55 -0700
X-Google-Sender-Auth: 7v6NTjA4aQXcNOvS5tWUTqBKp2Y
Message-ID: <CA+55aFyLk1AWxd9r2zfrKtpawPhw53k_rBdj8kq159i=hf6xsA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for 3.16-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 3:44 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>   git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

I've pulled this, but I was pretty close to saying "screw this shit".

Look at commit 9a630d15f16d, and pray tell me why those kinds of
commit logs are excusable?

That commit message is totally worthless noise. It doesn't explain
what it merges, much less give any explanation of *why* it is a merge.

Merges need explanations too. Tell what the branch you are merging
does, and why you are doing the merge. Yeah, in this case the "branch"
contains a single commit, but that *still* doesn't excuse not telling
what the merge is, and why it exists at all.

Seriously. Do "git log --merges" on current git, and look at the
discrepancy between merge commit messages. That commit 9a630d15f16d is
pure garbage.

It's not the only crappy one, but it really does stand out. There are
other one-liners in there, but even then they tend to have at least
*some* semblance of actual information in them, ie

    Merge branch 'for-v3.16/ti-clk-drv' of
github.com:t-kristo/linux-pm into clk-next

at least shows that there's a topic branch with a reasonable name, and
where it comes from. I'd really prefer it to talk about what it merges
and why, but it's still *much* better than your completely
information-free merge message.

                Linus
