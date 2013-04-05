Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162863Ab3DEWJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:09:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40114 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162790Ab3DEWJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:09:06 -0400
Message-ID: <515F4B60.60302@zytor.com>
Date: Fri, 05 Apr 2013 15:08:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Julien Tinnes <jln@google.com>
CC: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <20130405071144.GB26889@gmail.com> <CAKyRK=h0sDFn6vqdKwmWds4EubqwnqVYG4JgKk=5-EDV7dJ36g@mail.gmail.com>
In-Reply-To: <CAKyRK=h0sDFn6vqdKwmWds4EubqwnqVYG4JgKk=5-EDV7dJ36g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 03:06 PM, Julien Tinnes wrote:
> 
> Speaking of IDT, and to capture some off-thread discussion here, we
> should remember that the "SGDT" and "SIDT" instructions aren't
> privileged on x86, so user-land can leak these out without any way for
> the kernel to intercept that.
> 
> Adding their own random offsets to these two tables would be very
> useful. This could be done in a later patchset of course.
> 

Yes, if the GDT or IDT position is at all correlated to the kernel
position this is pointless.

	-hpa


