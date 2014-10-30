Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161460AbaJ3Wsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:48:50 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:48418 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035AbaJ3Wss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <5452B241.5010603@amacapital.net>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
	<5452B241.5010603@amacapital.net>
Date: Thu, 30 Oct 2014 15:48:47 -0700
X-Google-Sender-Auth: d-c0p2wnTgcGVzpYtLpXfZhntjY
Message-ID: <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Rannaud <e@nanocritical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 2:48 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Looks sensible.  Should this be Cc: stable?

Agreed. Will apply and add the stable cc.

                Linus
