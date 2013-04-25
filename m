Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab3DYWFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:05:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33318 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903Ab3DYWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:05:23 -0400
Date: Fri, 26 Apr 2013 00:05:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] extable: Flip the sorting message
Message-ID: <20130425220518.GC312@pd.tnic>
References: <1366023109-12098-1-git-send-email-bp@alien8.de>
 <5179A625.1080502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5179A625.1080502@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 02:54:45PM -0700, H. Peter Anvin wrote:
> On some architectures we sort at runtime, on others we sort at build
> time.
>
> Is there any reason for a message at all here?

The original pr_notice was arguably a debugging aid to verify that the
build-time sorting has actually happened. I flipped it because it wasn't
telling us anything interesting and we know that the sorting works -
we've been staring at that message for a couple of kernel releases
already :-)

One possible reason for having it flipped is to encourage runtime
sorting arches to convert to build time sorting.

But silencing this completely is also ok with me - I don't care all that
much.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
