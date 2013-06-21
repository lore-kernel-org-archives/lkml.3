Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423408Ab3FUQhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:37:20 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:52090 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423115Ab3FUQhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:37:18 -0400
MIME-Version: 1.0
In-Reply-To: <201306210055.r5L0tNKi027615@terminus.zytor.com>
References: <201306210055.r5L0tNKi027615@terminus.zytor.com>
Date: Fri, 21 Jun 2013 06:37:17 -1000
X-Google-Sender-Auth: TcNIYceIWthStHUTMSN9nwG_Dlo
Message-ID: <CA+55aFyKrJ36fLeR_F2=CWh1aAMXUxOcz9Qd3rc8SjQ-caXyBg@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes for v3.10-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Joshua Covington <joshuacov@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 2:55 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> This series fixes a couple of build failures, and fixes MTRR cleanup
> and memory setup on very specific memory maps.  Finally, it fixes
> triggering backtraces on all CPUs, which was inadvertently disabled on
> x86.

Hmm. You also just snuck an EFI fix in there after the pull request,
without sending an update email. Tssk.

                Linus
