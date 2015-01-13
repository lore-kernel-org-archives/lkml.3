Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbbAMFEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:04:25 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:39597 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbAMFEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:04:23 -0500
Message-ID: <54B4A754.9060405@landley.net>
Date: Mon, 12 Jan 2015 23:04:20 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [PATCH] x86, build: replace Perl script with Shell script
References: <20150113021750.GA24160@www.outflux.net>
In-Reply-To: <20150113021750.GA24160@www.outflux.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 08:17 PM, Kees Cook wrote:
> Commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
> added Perl to the required build environment. This reimplements in shell
> the Perl script used to find the size of the kernel with bss and brk added.
> 
> Reported-by: Rob Landley <rob@landley.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org

I just noticed earlier today that my version doesn't notice if objdump
isn't in the $PATH. (Happens if you're cross compiling and not all
binaries prefixed.)

Other than that:

Acked-by: Rob Landley <rob@landley.net>

(I don't have a setup with gold to test...)

Rob
