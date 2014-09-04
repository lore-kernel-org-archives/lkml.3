Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIDPm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:42:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51040 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaIDPm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:42:58 -0400
Date: Thu, 4 Sep 2014 17:42:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140904154246.GA10884@nazgul.tnic>
References: <20140831201126.GB12628@khazad-dum.debian.net>
 <20140901051302.GA28402@nazgul.tnic>
 <5404A035.3070707@zytor.com>
 <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
 <20140901195921.GA18675@khazad-dum.debian.net>
 <20140902063354.GA32105@nazgul.tnic>
 <20140902131651.GA10691@khazad-dum.debian.net>
 <20140903064015.GA3941@nazgul.tnic>
 <20140903124302.GA18507@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140903124302.GA18507@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:43:02AM -0300, Henrique de Moraes Holschuh wrote:
> Half the things you'd usually do when writing kernel code cannot be done
> that early, that's how.  It is not that the code is bad or especially
> fragile (at least not the core or the AMD driver.  The Intel driver is
> convoluted).

Right, it could use some cleaning up.

> You have fixed several such bugs recently, commit ids:
> 75a1ba5b2c529db60ca49626bcaf0bddf4548438,
> 84516098b58e05821780dc0b89abcee434b4dca5,
> 5335ba5cf475369f88db8e6835764efdcad8ab96.

Those were unfortunate because the original patches didn't get tested
enough and got applied. This is not happening again on my watch.

> Yes. It is a stop gap solution, I never claimed it to be anything
> else.
>
> What I did claim is that it is going to be a far more user-friendly
> stop gap than the "boot from rescue media" option.

Ok, we have it now and we can use it if needed. All is good.

-- 
Regards/Gruss,
    Boris.
--
