Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaLAV3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:29:24 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:60305 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaLAV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:29:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Mon, 01 Dec 2014 22:28:39 +0100
Message-ID: <2153824.ln4mvSCK1X@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141201212820.6a7fc4b0@bbrezillon>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <2476626.8iiXDzb2Te@wuerfel> <20141201212820.6a7fc4b0@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SfAjEecnh8b6HsxtsU5wTQvp+IKQNFPMw/mu7Y3wD7Q
 g6bJQIy3nP9CZwPXbuDeWzqXfYHmV4pVy4z+OhKJPP9xvqaz1f
 kU4JC1AaIDWVMkxzy4yUQOJofIdFPHR8PrZVASkWN9+b1nPlGF
 H6Kp28yHVdPmly2KfNllmhKW4a2b9VN/Y7vYmNX1fKFXUGIZiL
 cAoAAqDQ6j0qFAAMCYVV9kflnWmMEHSpiR/ZX5snzwvlRGSQ/V
 lCpXelnN6aCJmE5y+mPRwdHQxNWAzN/KIgCPJ6JZUFKWsv8xNG
 8to6WymG1CWPQgt6R8hbkkzLfKgYa3GO5wVipLw4qSVzvH89DG
 73ELgCzhyxdK3/E3P6QE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 21:28:20 Boris Brezillon wrote:
> > On Monday 01 December 2014 19:29:23 Boris Brezillon wrote:
> > > On Mon, 01 Dec 2014 17:26:27 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
> > > 
> > > #define AT91_EBICSA_REGFIELD(off)                   \
> > >     REG_FIELD(ebicsa_off, AT91_MATRIX_EBI_NUM_CS - 1)
> > > 
> > 
> > That would be acceptable too, but what I really meant is one step further:
> > 
> > static const struct reg_field at91sam9260_ebi_csa = 
> >       REG_FIELD(AT91SAM9260_MATRIX_EBICSA_OFF, 0, AT91_MATRIX_EBI_NUM_CS - 1);
> 
> That's what I did in the first place (in a version I didn't submitted),
> and I guess I'll go for that one unless you really prefer the
> alternative (I ran into a lot of trouble with DT bindings ABI
> stability, and I'd prefer to keep DT bindings as simple as
> possible).

Ok, that's good then.

	Arnd
