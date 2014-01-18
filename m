Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaARLId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:08:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56900 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaARLIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:08:31 -0500
Date: Sat, 18 Jan 2014 12:08:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
Message-ID: <20140118110829.GA2071@amd.pavel.ucw.cz>
References: <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <20140117222806.GB13930@amd.pavel.ucw.cz>
 <20140117225013.GE14649@pd.tnic>
 <52D9B408.4020007@zytor.com>
 <20140118002926.GA22185@amd.pavel.ucw.cz>
 <52D9D6FC.7050100@zytor.com>
 <20140118020155.GA24158@amd.pavel.ucw.cz>
 <20140118104231.GA15466@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140118104231.GA15466@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-01-18 11:42:31, Borislav Petkov wrote:
> On Sat, Jan 18, 2014 at 03:01:55AM +0100, Pavel Machek wrote:
> > I'd say that proposed "your bios has a bug"
> 
> You can always unconditionally print "your bios has a bug". Just like
> that. Without even looking.

Yeah, and we have linux-firmware testing toolkits, to discourage buggy
bioses. In this case it is "your bios has rare and dangerous bug, see CVS-1234".

> If you want to add a warning yourself, you can put it in rc.local using
> userspace goodies like msr-tools. With them you can toggle that bit ad
> absurdum - no need for the kernel except msr.ko.

?? By the time userspace is booted, you have overwritten the MSR, and
information, if the BIOS is buggy, was lost.

So linux-firmware testing toolkit actually has no chance to report
this one.


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
