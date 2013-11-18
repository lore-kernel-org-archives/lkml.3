Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KRLZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:25:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44587 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3KRLZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:25:06 -0500
Date: Mon, 18 Nov 2013 12:25:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Roskin <proski@gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        Noam Camus <noamc@ezchip.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] x86: Add support for uncompressed kernel images
Message-ID: <20131118112504.GA27541@pd.tnic>
References: <20131118094807.GC31741@ab42.lan>
 <1384768311-8824-2-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1384768311-8824-2-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:51:51AM +0100, Christian Ruppert wrote:

How about a commit message ... somewhere around here would be nice, for
example :)

> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> ---
>  arch/x86/Kconfig                  |    1 +
>  arch/x86/boot/compressed/Makefile |   14 ++++++------
>  arch/x86/boot/compressed/misc.c   |    4 +++
>  lib/decompress_copy.c             |   44 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 56 insertions(+), 7 deletions(-)
>  create mode 100644 lib/decompress_copy.c

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
