Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaLLXCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:02:49 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41459 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaLLXCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:02:48 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412121539300.16494@nanos>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
Date: Fri, 12 Dec 2014 15:02:47 -0800
X-Google-Sender-Auth: b7_CHZF4f1FB91TIiZg6aY0Gt6U
Message-ID: <CA+55aFzf9s+zz3h4hL3Xv8ni+1DR93yXx-gh44XunVP1hbW9pQ@mail.gmail.com>
Subject: Re: Status of tip/x86/apic
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 12:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> This will block other things in that area for a while, but it's the
> only sane decision at the moment, unless Linus insists on pulling the
> lot and promises to deal with the fallout. :)

Heh, no. I'll happily vote for a calm xmas season.

                    Linus
