Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3GGSHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 14:07:04 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:49514 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3GGSHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 14:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130702174402.GA21817@windriver.com>
References: <20130702174402.GA21817@windriver.com>
Date: Sun, 7 Jul 2013 11:07:00 -0700
X-Google-Sender-Auth: FuzzTyfkesmzm78F9CxBf8fVwHg
Message-ID: <CA+55aFzoMm=_VbJJknFC=cVzbq2Xq3kN9X-Xsr=rSoZVPHZNPw@mail.gmail.com>
Subject: Re: [GIT PULL] Stage 1 of __cpuinit removal
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 10:44 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
>
>  include/asm-generic/vmlinux.lds.h | 12 ---------
>  include/linux/init.h              | 19 +++++++-------
>  scripts/mod/modpost.c             | 52 +++++++--------------------------------
>  3 files changed, 19 insertions(+), 65 deletions(-)

Your diffstat is odd, and doesn't match mine. But I'm pretty sure
yours is just plain wrong, because your numbers just don't add up.

You have:
  12+19+52 = 83
  19+65 = 84

how the heck did you manage that?

The correct diffstat would seem to be

 include/asm-generic/vmlinux.lds.h | 12 ------------
 include/linux/init.h              | 19 +++++++++---------
 scripts/mod/modpost.c             | 52
+++++++++----------------------------------------
 3 files changed, 18 insertions(+), 65 deletions(-)

(where both set of numbers add up to 83).

                  Linus
