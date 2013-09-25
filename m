Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3IYRzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:55:55 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33018 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3IYRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:55:53 -0400
Date: Wed, 25 Sep 2013 10:55:27 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: "olof@lixom.net" <olof@lixom.net>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "avinashphilipk@gmail.com" <avinashphilipk@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v6 1/4] ARM: OMAP2+: cleaned-up DT support of various
 ECC schemes
Message-ID: <20130925175527.GA23337@ld-irv-0074.broadcom.com>
References: <1378986619-26765-1-git-send-email-pekon@ti.com>
 <1378986619-26765-2-git-send-email-pekon@ti.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA15ED7@DBDE04.ent.ti.com>
 <20130925134619.GG10746@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925134619.GG10746@radagast>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekon,

On Wed, Sep 25, 2013 at 08:46:19AM -0500, Felipe Balbi wrote:
> + akpm
> 
> On Tue, Sep 24, 2013 at 01:04:05PM -0500, Gupta, Pekon wrote:
> > 
> > > 
> > > This patch
> > > - updates DT binding for selection of ecc-scheme
> > > - updates DT binding for detection of ELM h/w engine
> > > - removes following obselete ECC schemes
> > > 	OMAP_ECC_HAMMING_CODE_DEFAULT (S/W based 1-bit Hamming
> > > ECC)
> > > 	OMAP_ECC_HAMMING_CODE_HW_ROMCODE (H/W based 1-bit
> > > Hamming ECC scheme)
> > > - updates DT binding documentation for mtd/gpmc-nand
> > > 
> > > Signed-off-by: Pekon Gupta <pekon@ti.com>
> > > ---
> > 
> > Dear Olof and other DT Maintainers,
> > 
> > This patch series has missed multiple merge windows, and
> > much of the other development work on mtd/nand/omap
> > driver is gated due to this.

Also, to be fair here: you only started CC'ing the appropriate DT
people/list around v4, after which you got a (somewhat) prompt and
thorough review of the DT bindings. Then several months passed before
you addressed the reviews. So the "multiple merge windows" is not
entirely to be blamed on others ;)

Brian
