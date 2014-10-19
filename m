Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaJSUFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 16:05:25 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:49361 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaJSUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 16:05:23 -0400
MIME-Version: 1.0
In-Reply-To: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
Date: Sun, 19 Oct 2014 13:05:22 -0700
X-Google-Sender-Auth: -bjEyEq4-0U-w6tQyfLHGl0PxDc
Message-ID: <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 9:07 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> gcc5 changes the default standard to c11, rather than gnu89, which
> makes kernel build unhappy.

Hmm. Just how unhappy does it make it? Maybe we can instead try to
make the build happier with some minimal changes? Or is it really
painful?

                      Linus
