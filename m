Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaJERtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:49:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41723 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaJERtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <54311E8E.80906@gmail.com>
References: <54311E8E.80906@gmail.com>
Date: Sun, 5 Oct 2014 10:49:17 -0700
X-Google-Sender-Auth: bQ-_QEUHFp8I-zqoQFVPGVEO0pA
Message-ID: <CA+55aFzRnx7mR4P-tRg=DO2M9B0_yvH34bBKNg2q1nWWd3S79g@mail.gmail.com>
Subject: Re: [GIT PULL] S+core : Patches for building allmodconfig and for
 removing useless
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lennox Wu <lennox.wu@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2014 at 3:33 AM, Lennox Wu <lennox.wu@gmail.com> wrote:
>
>   git://github.com/sctscore/linux-off.git tags/for-linus

That's a tag, but it's not a *signed* tag.

I don't pull unsigned data from open sites like github. You need to
use "git tag -s" to create a proper pgp signed tag.

                Linus
