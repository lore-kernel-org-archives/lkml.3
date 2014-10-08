Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaJHVyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:54:52 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61318 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbaJHVyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:54:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410082001460.4292@nanos>
References: <alpine.DEB.2.11.1410082001460.4292@nanos>
Date: Wed, 8 Oct 2014 17:54:49 -0400
X-Google-Sender-Auth: FbwcoDVv1oUEkV4AABdwY73R9ZA
Message-ID: <CA+55aFwF+YjvoFbwemtkkD76_=b5dQdE7HC0ELXKhogbWZCusQ@mail.gmail.com>
Subject: Re: [GIT pull] timer changes for 3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 2:12 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> please pull the latest timers-core-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus
>
> Nothing really exciting this time:
>
>  - A few fixlets in the NOHZ code

.. but apparently *still* not the fixes from Frederic for the issue
that people are complaining about killing their machines in 3.17.

WTF? What happened to those?

               Linus
