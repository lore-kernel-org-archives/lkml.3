Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaKBKdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 05:33:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32911 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKBKdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 05:33:02 -0500
Date: Sun, 2 Nov 2014 11:33:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141102103300.GB5229@pd.tnic>
References: <20141102102212.GA7034@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141102102212.GA7034@polanet.pl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 11:22:12AM +0100, Tomasz Pala wrote:
> While both K8 and F10h are AMD64 CPUs, EDAC doesn't require them to run
> in long mode; AMD_NB dependency is enough.

Not enabling it on 32-bit was a conscious decision for the simple reason
that with the current DIMM sizes, you can have 1 or 2 DIMMs tops which
you can use on 32-bit and having a fat driver mapping memory errors to
DIMMs in that case does seem like a waste of time, energy, resources...
you name it.

I guess I'll add a note about this in the Kconfig text because I keep
getting patches about this once every couple of months :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
