Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162409Ab3DESSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:18:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38478 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162360Ab3DESSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:18:13 -0400
Message-ID: <515F1541.40509@zytor.com>
Date: Fri, 05 Apr 2013 11:17:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <515DE0C9.3030709@zytor.com> <20130405080418.GG26889@gmail.com>
In-Reply-To: <20130405080418.GG26889@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 01:04 AM, Ingo Molnar wrote:
> 
> The cost of 64-bit RIPs is probably measurable both in cache footprint and 
> in execution speed.
> 

Well, "probably" usually translates to "worth measuring" to me.

> Random runtime shuffling of the kernel image - is that possible with 
> existing toolchains?

I wanted to point out... yes this is hard, but it has the ability to be
*much* stronger than any other form of KASLR simply because it means
that a single infoleak doesn't give everything else away.

	-hpa


