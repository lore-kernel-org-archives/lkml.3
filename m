Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab3KZUMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:12:14 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:32908 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3KZUMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:12:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131126150415.2ecdb563@gandalf.local.home>
References: <20131126150415.2ecdb563@gandalf.local.home>
Date: Tue, 26 Nov 2013 12:12:12 -0800
X-Google-Sender-Auth: BiT9EOTDpamHv2kxGEJ3fTt-Vt4
Message-ID: <CA+55aFzSYFMktYLBk6q+5uTS7SS5ufz3ofyZ4ZWcn4r-qSDgGA@mail.gmail.com>
Subject: Re: [PATCH] ima: Fix build failure of redefinition of integrity_init_keyring()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 12:04 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> If CONFIG_INTEGRITY_SIGNATURE is set, but
> CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not, then we get the following
> build failure:

Didn't this already get fixed by the reverts I did and Mimi acked?

Commits 4c1cc40a2d49 ("Revert "KEYS: verify a certificate is signed by
a 'trusted' key"") and 34ef7bd3823b ("Revert "ima: define '_ima' as a
builtin 'trusted' keyring"") to be exact.

              Linus
