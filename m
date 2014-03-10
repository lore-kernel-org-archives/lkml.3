Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaCJKZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:25:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45351 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaCJKZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:25:50 -0400
Date: Mon, 10 Mar 2014 11:25:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Mohr <andi@lisas.de>, Dennis Mungai <dmngaie@gmail.com>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        devzero@web.de
Subject: Re: [PATCH] x86: Add forcepae parameter for booting PAE kernels on
 PAE-disabled Pentium M
Message-ID: <20140310102546.GB14808@pd.tnic>
References: <20140228140043.GA12157@debian.local>
 <20140302205619.GA8676@rhlx01.hs-esslingen.de>
 <20140303080432.GA25489@localhost>
 <20140303192939.GD31265@pd.tnic>
 <20140304050122.GA3740@localhost>
 <5e866e2a-ea92-43f8-ae67-23f6052c91c8@email.android.com>
 <20140304060559.GA547@localhost>
 <20140304104447.GA4891@pd.tnic>
 <20140307114040.GA4997@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140307114040.GA4997@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:40:42PM +0700, Chris Bainbridge wrote:
> From: Chris Bainbridge <chris.bainbridge@gmail.com>
> 
> Many Pentium M systems disable PAE but may have a functionally usable PAE 
> implementation. This adds the "forcepae" parameter which bypasses the boot 
> check for PAE, and sets the CPU as being PAE capable. Using this parameter 
> will taint the kernel with TAINT_CPU_OUT_OF_SPEC.
> 
> Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>

Looks ok to me.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
