Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaGOQSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:18:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49819 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbaGOQSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:18:05 -0400
Date: Tue, 15 Jul 2014 18:18:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: Re: linux-next: manual merge of the char-misc tree with the ia64 tree
Message-ID: <20140715161802.GB4775@pd.tnic>
References: <20140715164349.5807b892@canb.auug.org.au>
 <20140715134458.GB17795@kroah.com>
 <20140715134920.GC17795@kroah.com>
 <3908561D78D1C84285E8C5FCA982C28F3285CF7A@ORSMSX114.amr.corp.intel.com>
 <20140715153613.GA4775@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3285D02E@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3285D02E@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 03:57:42PM +0000, Luck, Tony wrote:
> Oops - not quite. We moved creation of the EDAC trace point into
> drivers/ras/ras.c and edac is not x86 specific.
>
> We also create the PCIe AER tracepoint there too - PCIe is not x86
> specific.

Right, but AFAIK, only x86 uses those. And frankly, we don't know
whether other arches would have interest in those or would like to grow
their own.

So, I don't have an idea whether we want to make the whole RAS stuff
arch-specific or we have to talk about it or we have to leave us that
option open and so on...

It is hard to say.

One example to mud the situation even more :-):

The APEI stuff is apparently being used by arm now too, but without the
NMI which is x86-specific. Carving that whole thing out took a bit of
work but it got done.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
