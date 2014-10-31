Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaJaSxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:53:12 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:37850 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaJaSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:53:10 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
	<5452B241.5010603@amacapital.net>
	<CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
	<CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
	<CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
	<20141031084220.GA29085@infradead.org>
	<CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
Date: Fri, 31 Oct 2014 11:53:09 -0700
X-Google-Sender-Auth: xxFz3mw7_z2G28tIfszi9gAhW-E
Message-ID: <CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Rannaud <e@nanocritical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:44 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Does the patch in this thread not fix that?

It should. Modulo the glibc problem that makes it hard to actually set
the mode properly.

                          Linus
