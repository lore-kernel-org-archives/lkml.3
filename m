Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaJTJRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:17:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36800 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbaJTJRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:17:16 -0400
Date: Mon, 20 Oct 2014 11:16:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Embedded <linux-embedded@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: v3.18-rc1 bloat-o-meter
Message-ID: <20141020091653.GA3524@pd.tnic>
References: <alpine.DEB.2.02.1410201018230.24954@ayla.of.borg>
 <20141020090637.GA3654@pd.tnic>
 <CAMuHMdV5VPEqJ2WeZTc=Tg_vSRJPYgzQib9m-_fnqLzJ_vpDdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdV5VPEqJ2WeZTc=Tg_vSRJPYgzQib9m-_fnqLzJ_vpDdA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:09:28AM +0200, Geert Uytterhoeven wrote:
> Sure. Compile two kernel images, and run
> 
>     scripts/bloat-o-meter <image1> <image2>

Ha, that's even upstream :-)

Thanks Geert!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
