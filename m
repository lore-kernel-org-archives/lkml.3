Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3FFWXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:23:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49793 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab3FFWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:23:37 -0400
Date: Fri, 7 Jun 2013 00:23:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kim Phillips <kim.phillips@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7] arm: use built-in byte swap function
Message-ID: <20130606222320.GT20972@pd.tnic>
References: <alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
 <20130221005221.15279b1372501af12c1e4f32@freescale.com>
 <alpine.LFD.2.03.1302211134160.6419@syhkavp.arg>
 <20130221203327.6558f89277468f7ffffa6506@freescale.com>
 <alpine.LFD.2.03.1302212219100.6419@syhkavp.arg>
 <20130222194032.f7b44aefa5e2723d16767a1b@freescale.com>
 <1361661654.18110.102.camel@shinybook.infradead.org>
 <20130523114654.1f273241725205c6703b2226@freescale.com>
 <20130523231336.GS18614@n2100.arm.linux.org.uk>
 <20130606221234.GQ18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130606221234.GQ18614@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 11:12:34PM +0100, Russell King - ARM Linux wrote:
> That will ultimately then give sfr a conflict which should be trivial
> to resolve - and hopefully we'll find out who's carrying the LZ4 patch
> and putting it into linux-next.

That should be akpm:

http://ozlabs.org/~akpm/mmotm/broken-out/arm-add-support-for-lz4-compressed-kernel.patch

AFAICT.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
