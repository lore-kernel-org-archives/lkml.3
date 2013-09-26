Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3IZKo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:44:59 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1664 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756301Ab3IZKo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:44:57 -0400
Message-ID: <52441025.9030308@nod.at>
Date: Thu, 26 Sep 2013 12:44:53 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: linux-arch@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        geert@linux-m68k.org, ralf@linux-mips.org, lethal@linux-sh.org,
        Jeff Dike <jdike@addtoit.com>, gxt@mprc.pku.edu.cn,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/8] um: Do not use SUBARCH
References: <1377073172-3662-1-git-send-email-richard@nod.at> <1377073172-3662-3-git-send-email-richard@nod.at> <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com>
In-Reply-To: <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 12:40, schrieb Ramkumar Ramachandra:
> Richard Weinberger wrote:
> Forget all that. What matters is that upstream is still broken, and
> users are suffering. Despite a reasonable fix being submitted in July.

So, what exactly is broken in upstream?
make defconfig works as it always did.

make defconfig ARCH=um SUBARCH=x86 (or SUBARCH=i386) will create a defconfig for 32bit.
make defconfig ARCH=um SUBARCH=x86_64 one for 64bit.

Thanks,
//richard
