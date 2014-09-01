Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaIAFNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:13:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33018 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaIAFNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:13:33 -0400
Date: Mon, 1 Sep 2014 07:13:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140901051302.GA28402@nazgul.tnic>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140831194548.GA12628@khazad-dum.debian.net>
 <54037C07.8060703@zytor.com>
 <20140831201126.GB12628@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140831201126.GB12628@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 05:11:26PM -0300, Henrique de Moraes Holschuh wrote:
> > Probably more like something more like arch/x86/boot/cmdline.c.  Maybe
> > we could even make it sharable.
> 
> Looks like that would work, yes.

Guys, guys, please relax and check the code first: "dis_ucode_ldr".

-- 
Regards/Gruss,
    Boris.
--
