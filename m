Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3G3Tfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:35:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36278 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab3G3Tfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:35:32 -0400
Date: Tue, 30 Jul 2013 21:35:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ilari Stenroth <ilari.stenroth@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/cpu/intel.c needs an update for Haswell?
Message-ID: <20130730193530.GB23299@pd.tnic>
References: <kt91u2$jhs$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <kt91u2$jhs$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:50:49PM +0300, Ilari Stenroth wrote:
> Does somebody know why arch/x86/kernel/cpu/intel.c has
> tlb_flushall_shift detection logic for Ivy Bridge CPU family but not
> for Haswell? Maybe intel_cacheinfo.c needs to be checked for Haswell
> updates too.

Because someone needs to sit down and write it. Oh, and more
importantly, test it on real hardware.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
