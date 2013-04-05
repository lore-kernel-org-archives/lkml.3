Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161898Ab3DEPb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 11:31:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37282 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765499Ab3DEPbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:31:25 -0400
Message-ID: <515EEE25.1030402@zytor.com>
Date: Fri, 05 Apr 2013 08:30:45 -0700
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
> Random runtime shuffling of the kernel image - is that possible with 
> existing toolchains?
> 

Yes... the question is how much work we'd be willing to go through to
make it happen.

One approach: the kernel already contains a linker -- used for modules
-- and the bulk of the kernel could actually be composed to a "pile of
modules" that gets linked on boot.  This would provide very large
amounts of randomness.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

