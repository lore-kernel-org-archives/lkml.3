Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3ALSgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 13:36:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37263 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab3ALSgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 13:36:23 -0500
Date: Sat, 12 Jan 2013 19:36:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-ID: <20130112183619.GC10630@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Kosina <jkosina@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sasha Levin <levinsasha928@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Josh Boyer <jwboyer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Florian Tobias Schandinat <florianSchandinat@gmx.de>
References: <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
 <20121121125310.00625f55@pyramind.ukuu.org.uk>
 <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
 <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
 <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
 <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
 <20121227045301.GB17472@x1.alien8.de>
 <20121228115022.GA28009@S2101-09.ap.freescale.net>
 <20121228124026.GB12918@x1.alien8.de>
 <alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 10:37:15AM +0100, Jiri Kosina wrote:
> Still seeing it with current Linus' tree.
>   
>         Tested-by: Jiri Kosina <jkosina@suse.cz>
>   
> Anyone applying this, please?

Yeah, I'm still seeing it in -rc3. Linus, can you pick up Alan's patch
from https://patchwork.kernel.org/patch/1757061/ please?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
