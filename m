Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3ALSIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 13:08:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55871 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab3ALSIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 13:08:48 -0500
Date: Sat, 12 Jan 2013 19:08:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
Message-ID: <20130112180845.GB10630@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Woodhouse <dwmw2@infradead.org>, mingo@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	hpa@linux.intel.com, David.Woodhouse@intel.com,
	linux-tip-commits@vger.kernel.org
References: <1356040315.3198.51.camel@shinybook.infradead.org>
 <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
 <20130112170647.GA10659@liondog.tnic>
 <50F1A004.4090200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F1A004.4090200@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 09:40:20AM -0800, H. Peter Anvin wrote:
> Hiding it because it happens to be in a slightly illogical place seems
> completely backwards.

Sure, that's the lazy dude solution™ :-)

I could try to restructure arch/x86/Kconfig but is it worth the trouble
to fix the "slightly illogical" placing...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
