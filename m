Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3AaNYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:24:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59259 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab3AaNYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:24:05 -0500
Date: Thu, 31 Jan 2013 14:24:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130131132400.GH4926@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
References: <20130129202848.GE25415@pd.tnic>
 <5109A8F1.9040707@suse.cz>
 <5109B11C.2010400@suse.cz>
 <5170962.qHnbnlVDfx@vostro.rjw.lan>
 <20130131070926.GC4926@pd.tnic>
 <510A2B1C.1060108@suse.cz>
 <20130131131805.GG4926@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130131131805.GG4926@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 02:18:05PM +0100, Borislav Petkov wrote:
> > And if I pass nmi_watchdog=0 to the image kernel, it should be gone I
> > guess.
> 
> How do you pass options the image kernel?

Yep, passing "nmi_watchdog=0" to the kernel (both when you boot and
when you resume) fixes the issue - no more unknown NMIs. Did only 3 s/r
cycles though.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
