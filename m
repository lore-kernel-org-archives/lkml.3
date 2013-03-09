Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab3CILgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 06:36:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43947 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804Ab3CILgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 06:36:40 -0500
Date: Sat, 9 Mar 2013 12:36:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        ibm-acpi-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] x230: unhandled HKEY event 0x6050
Message-ID: <20130309113631.GA18133@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yves-Alexis Perez <corsac@debian.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	ibm-acpi-devel@lists.sourceforge.net,
	lkml <linux-kernel@vger.kernel.org>
References: <20130304213804.GE22274@pd.tnic>
 <20130307003016.GA21655@khazad-dum.debian.net>
 <1362816406.19016.16.camel@scapa>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362816406.19016.16.camel@scapa>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 09:06:46AM +0100, Yves-Alexis Perez wrote:
> Also see https://bugzilla.kernel.org/show_bug.cgi?id=51231 and
> https://patchwork.kernel.org/patch/2124861/

Great, another fit-the-hardware-to-the-software idiocy because those
dimwits which call their pile of stinking software running in ring 0 the
parts of a house want to control every-f*cking-thing. Sigh :(.

Thanks for the links Yves-Alexis, certainly a sad read.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
