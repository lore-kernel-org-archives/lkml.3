Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBBTIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 14:08:11 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:35936 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaBBTII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 14:08:08 -0500
MIME-Version: 1.0
In-Reply-To: <1391310232-8520-1-git-send-email-hpa@linux.intel.com>
References: <1391310232-8520-1-git-send-email-hpa@linux.intel.com>
Date: Sun, 2 Feb 2014 11:08:07 -0800
X-Google-Sender-Auth: w4wy4UVFAlQVk1FJqJpcuynZxEg
Message-ID: <CA+55aFyuOS==c5iihr3__OECkwdwd7WuzEieJ1UvHsgoXW+7bQ@mail.gmail.com>
Subject: Re: [PATCH RFC] compat: Get rid of (get|put)_compat_time(val|spec)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Mateusz Guzik <mguzik@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 7:03 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> Clean it up by favoring the full-service version; the limited version
> is replaced with double-underscore versions static to kernel/compat.c.

Ack. Make it so. I assume you've tested this on x32 (and hopefully
x86-32 on a 64-bit kernel), and that I will get this through the x86
git trees?

                 Linus
