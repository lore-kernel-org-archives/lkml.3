Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3IFSJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:09:28 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:49938 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3IFSJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:09:24 -0400
MIME-Version: 1.0
In-Reply-To: <52299BD2.2020307@monstr.eu>
References: <52299BD2.2020307@monstr.eu>
Date: Fri, 6 Sep 2013 11:09:23 -0700
X-Google-Sender-Auth: SgK_eEtyYq5lPDnWD-3DeHcT6rA
Message-ID: <CA+55aFw6XSH2J4DALGF9Mp-sZHpFwiZnwoGYjiXH=rz5NkSeZA@mail.gmail.com>
Subject: Re: [GIT PULL] arch/microblaze changes for 3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 2:09 AM, Michal Simek <monstr@monstr.eu> wrote:
> Hi Linus,
>
> please pull these Microblaze patches to your tree.

Hmm. You've started using signed tags, nice. I just wonder why you use
use one that seems to be a relatively weak 1024-bit key (ID: 294A0C21)
when you have stronger ones available?

Not a huge deal, I'm just wondering.

            Linus
