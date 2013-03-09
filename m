Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3CIWNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 17:13:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56619 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab3CIWNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 17:13:20 -0500
Date: Sat, 9 Mar 2013 23:13:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Yves-Alexis Perez <corsac@debian.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] x230: unhandled HKEY event 0x6050
Message-ID: <20130309221312.GB18316@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Yves-Alexis Perez <corsac@debian.org>,
	ibm-acpi-devel@lists.sourceforge.net,
	lkml <linux-kernel@vger.kernel.org>
References: <20130304213804.GE22274@pd.tnic>
 <20130307003016.GA21655@khazad-dum.debian.net>
 <1362816406.19016.16.camel@scapa>
 <20130309113631.GA18133@pd.tnic>
 <20130309204913.GA7559@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130309204913.GA7559@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 05:49:13PM -0300, Henrique de Moraes Holschuh wrote:
> Hmm, I don't follow.  thinkpad-acpi does run on ring 0, so was that aimed at
> me?

Huh, is "thinkpad-acpi" the name of a part of a house? :-)

> Or are you complaining about the Win-8 bug-to-bug compatibility madness
> Lenovo added to the ACPI firmware?

Of course, I was simply ranting at the fact that hw vendors like lenovo
need to do all kinds of dancing in the BIOS just so they can get their
windoze certification. I know, I know, they don't have a choice and we
have more of those windoze workarounds in the kernel but we shouldn't.

Btw, what your signature says is very fitting to the occasion. :)

> -- 
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
