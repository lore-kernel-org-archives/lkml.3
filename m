Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab3CAKJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:09:15 -0500
Received: from smtp-out.abv.bg ([194.153.145.80]:42078 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3CAKJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:09:13 -0500
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=jm+3SdBZt77XhyhBU3G3fIvJQr0qt2J7sv+YKe65EBJauH3jSPYRoANq8AqbFSLn2
	KL+zNd/6ezm5fkuRQ5rZ5w7gL8r/y5cxLK2nZcaFDYuapbufI6vhzNmpPl00MFZsuWw
	meG12jJFdrQadu+h1KfZmvXof0LugWo6vjcOIR8=
Date: Fri, 1 Mar 2013 12:09:12 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: pali.rohar@gmail.com, tony@atomide.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <604513288.26328.1362132552062.JavaMail.apache@mail83.abv.bg>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 213.226.63.174
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Unfortunately it is necessary, on RX-51 PPA/NOLO leaves IBE bit unset.


 >-------- Оригинално писмо --------
 >От:  Peter De Schrijver 
 >Относно: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
 >До: Pali Rohár 
 >Изпратено на: Петък, 2013, Март 1 11:43:14 EET
 >
 >
 >On Thu, Feb 28, 2013 at 10:42:28AM +0100, Pali Rohár wrote:
 >> Signed-off-by: Ivaylo Dimitrov 
 >> Signed-off-by: Pali Rohár 
 >> ---
 >>  arch/arm/mach-omap2/Makefile            |    1 +
 >>  arch/arm/mach-omap2/board-rx51-secure.c |   66 +++++++++++++++++++++++++++++++
 >>  arch/arm/mach-omap2/board-rx51-secure.h |   36 +++++++++++++++++
 >>  arch/arm/mach-omap2/board-rx51-smc.S    |   34 ++++++++++++++++
 >>  arch/arm/mach-omap2/board-rx51.c        |    7 ++++
 >>  5 files changed, 144 insertions(+)
 >>  create mode 100644 arch/arm/mach-omap2/board-rx51-secure.c
 >>  create mode 100644 arch/arm/mach-omap2/board-rx51-secure.h
 >>  create mode 100644 arch/arm/mach-omap2/board-rx51-smc.S
 >> 
 >
 >Is this necessary? I thought the PPA sets this bit?
 >
 >Cheers,
 >
 >Peter.
 >
