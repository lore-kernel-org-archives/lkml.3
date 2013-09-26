Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3IZMBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:01:05 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55769 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab3IZMBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <52442108.1020304@nod.at>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
 <1377073172-3662-3-git-send-email-richard@nod.at> <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com>
 <52441025.9030308@nod.at> <CALkWK0k5neR50h+AWEF5AgnpbgWMitZUnbv_caVzt6HiUA6mXg@mail.gmail.com>
 <52441407.9010603@nod.at> <CALkWK0=FG4COEjv5+mu1JRiiFQ2k6vop1mhFPmAT4bjtYeK6nA@mail.gmail.com>
 <52442108.1020304@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 26 Sep 2013 17:30:20 +0530
Message-ID: <CALkWK0nm=9n7DiV0MaGKVLMs=vxAiiQUx=OFuOg-DinkdMej5A@mail.gmail.com>
Subject: Re: [PATCH 2/8] um: Do not use SUBARCH
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        geert@linux-m68k.org, ralf@linux-mips.org, lethal@linux-sh.org,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> I told you already that "make defconfig ARCH=um SUBARCH=x86" will spuriously
> create a x86_64 config on x86_64.
> This breaks existing setups.

I'll fix this and resubmit soon.

Thanks.
