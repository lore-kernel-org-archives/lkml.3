Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaDKSlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:41:06 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55135 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaDKSlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
Date: Fri, 11 Apr 2014 11:41:01 -0700
X-Google-Sender-Auth: NxGi1VpQ3njd09x5vDekn37KCd0
Message-ID: <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 11:27 AM, Brian Gerst <brgerst@gmail.com> wrote:
> Is this bug really still present in modern CPUs?  This change breaks
> running 16-bit apps in Wine.  I have a few really old games I like to
> play on occasion, and I don't have a copy of Win 3.11 to put in a VM.

Ok, so you actually do this on x86-64, and it currently works? For
some reason I thought that 16-bit windows apps already didn't work.

Because if we have working users of this, then I don't think we can do
the "we don't support 16-bit segments", or at least we need to make it
runtime configurable.

             Linus
