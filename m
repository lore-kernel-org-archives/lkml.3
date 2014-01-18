Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaARA3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 19:29:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35436 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaARA32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 19:29:28 -0500
Date: Sat, 18 Jan 2014 01:29:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
Message-ID: <20140118002926.GA22185@amd.pavel.ucw.cz>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <20140117222806.GB13930@amd.pavel.ucw.cz>
 <20140117225013.GE14649@pd.tnic>
 <52D9B408.4020007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D9B408.4020007@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-01-17 14:51:52, H. Peter Anvin wrote:
> On 01/17/2014 02:50 PM, Borislav Petkov wrote:
> > On Fri, Jan 17, 2014 at 11:28:06PM +0100, Pavel Machek wrote:
> >> Would it make sense to printk() a warning?
> > 
> > No because people come and start bitching about their dmesg containing
> > a warning and whether their hardware is b0rked without even reading the
> > actual words.

Have you checked your dmesg recently? Normal people don't read
it... it is just too much of it.

> Printing a warning is appropriate if we can't actually fix the problem
> in the OS.  If we actually make the problem go away then we have just
> done our job and we can be done with it.

I disagree. Older kernel versions still may have problem, etc.

We normally do print warnings for problems we work around. We want
vendors to fix their hardware, too...

ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT -
0xBDB5FF40/0x00000000BDB64F40, using 32 (20131115/tbfadt-522)
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
