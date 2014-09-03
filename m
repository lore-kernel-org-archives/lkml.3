Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaICGk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:40:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54136 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaICGkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:40:25 -0400
Date: Wed, 3 Sep 2014 08:40:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140903064015.GA3941@nazgul.tnic>
References: <20140831194548.GA12628@khazad-dum.debian.net>
 <54037C07.8060703@zytor.com>
 <20140831201126.GB12628@khazad-dum.debian.net>
 <20140901051302.GA28402@nazgul.tnic>
 <5404A035.3070707@zytor.com>
 <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
 <20140901195921.GA18675@khazad-dum.debian.net>
 <20140902063354.GA32105@nazgul.tnic>
 <20140902131651.GA10691@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140902131651.GA10691@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 10:16:51AM -0300, Henrique de Moraes Holschuh wrote:
> Things do go wrong in other ways, not just corrupt microcode data/initramfs
> images.
> 
> This stuff runs too early.  It is easy to break, and annoying to debug.

How is this stuff easy to break? Please stop with the conjectures and
give concrete issues, if any.

> Although, on the corrupted microcode topic, I have this very strong
> feeling that at least the Intel driver would benefit from a careful
> audit on the microcode container handling if we want to be sure it
> won't do stupid things when fed specially crafted hostile data.

If loading the microcode can disrupt the system (and not simply be
ignored if faulty) then we have to fix that. Disabling the loader is only
a stop-gap measure in such situation anyway - not a real solution.

-- 
Regards/Gruss,
    Boris.
--
