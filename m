Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbaFTSFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:05:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53813 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091AbaFTSFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:05:31 -0400
Date: Fri, 20 Jun 2014 20:05:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
Message-ID: <20140620180523.GF11391@pd.tnic>
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
 <20140620161740.BFB00798@viggo.jf.intel.com>
 <53A46008.5060509@zytor.com>
 <53A4619C.8020100@sr71.net>
 <53A46365.6090101@zytor.com>
 <20140620174345.GD11391@pd.tnic>
 <53A473AA.7050301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A473AA.7050301@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:47:22AM -0700, H. Peter Anvin wrote:
> This is run before static_cpu_has().

static_cpu_has_safe() then - I didn't do it for no reason :-)

> The point, though, was that we "enforce" (taint) on 32 bits but not on
> 64 bits, which is clearly wrong.

Yeah, K7 is 32-bit only.

> My inclination is to completely kill amd_k7_smp_check() entirely,
> since noone seems to know when it actually matters and it is clearly
> historic.

I think DaveJ should know something about it - he gave that impression
last time when we were discussing 8c90487cdc64 ("Rename TAINT_UNSAFE_SMP
to TAINT_CPU_OUT_OF_SPEC").

CCed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
