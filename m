Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3AXPXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:23:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab3AXPXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:23:01 -0500
Date: Thu, 24 Jan 2013 16:25:44 +0100
From: Borislav Petkov <bp@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, ling.ma.program@gmail.com,
        mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Ma Ling <ling.ml@alipay.com>
Subject: Re: [Suggestion] [x86]: Compiler Option Os is better on latest x86
Message-ID: <20130124152544.GA13504@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@suse.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	ling.ma.program@gmail.com, mingo@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, Ma Ling <ling.ml@alipay.com>
References: <1356503537-4987-1-git-send-email-ling.ma@alipay.com>
 <20130124141733.GA14876@gmail.com>
 <20130124144612.GC13471@pd.tnic>
 <51014B9A.5080500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51014B9A.5080500@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 08:56:26AM -0600, H. Peter Anvin wrote:
> There has been occasional talk about a -Ok(ernel) option to gcc, but
> that would require someone to go through gcc and figure out what bits
> makes sense and which don't...

Yep, such an option has a great potential for us and, if done right,
would be very cool. It could probably be taught to insert HWEIGHT,
RDRAND, CLFLUSH and whatever other insns we have the inline asm versions
for... and query CPUID before that... uuh, nice stuff.

The alternative would be to fork gcc and call it kcc...

/me runs away pretty quickly without even turning back :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
