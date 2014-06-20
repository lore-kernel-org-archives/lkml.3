Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966513AbaFTSst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:48:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59070 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335AbaFTSsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:48:47 -0400
Date: Fri, 20 Jun 2014 20:48:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
Message-ID: <20140620184839.GI11391@pd.tnic>
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
 <20140620161740.BFB00798@viggo.jf.intel.com>
 <53A46008.5060509@zytor.com>
 <53A4619C.8020100@sr71.net>
 <53A46365.6090101@zytor.com>
 <20140620174345.GD11391@pd.tnic>
 <53A473AA.7050301@zytor.com>
 <20140620180523.GF11391@pd.tnic>
 <20140620181600.GA1331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140620181600.GA1331@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:16:00PM -0400, Dave Jones wrote:
> AMD sold two separate SKUs: the Athlon XP and the Athlon MP.
> Only the latter was supposedly "certified" for use in multi-processor
> boards.  People found out however that sometimes the XP's 'worked'
> if you modded them (see http://www.hardwaresecrets.com/article/How-to-Transform-an-Athlon-XP-into-an-Athlon-MP/24)

Haha, that was a fun read. Closing fuses with a pencil - this reminds me
of:

https://www.youtube.com/watch?v=6QihBIewyrY

> I doubt anyone is actually even running such a system any more on
> a modern kernel, and any weird crashes would be written off more by
> "you're running 10+ year old hardware, it's probably broken" than
> "it was never meant to do that".

Yeah, we can kill amd_k7_smp_check() but I don't see why - it doesn't
hurt anyone right now. I don't care all that much either way, though -
whatever.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
