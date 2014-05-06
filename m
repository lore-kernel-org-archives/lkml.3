Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaEFUf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:35:59 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:37901 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaEFUf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:35:58 -0400
MIME-Version: 1.0
In-Reply-To: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
Date: Tue, 6 May 2014 13:35:57 -0700
X-Google-Sender-Auth: S3vfKgs4tiz0jR_kyMRyeQNYydM
Message-ID: <CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 1:29 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> The only reason it's Signed-off-by is that I agree to the DCO.
> That should not be construed to mean that anyone should apply
> this patch.  It's an abomination and it will do terrible,
> terrible things.

Heh. That is pretty disgusting. But I guess it could be interesting
for timing. BRB.

          Linus
