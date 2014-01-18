Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaARLbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:31:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60851 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaARLbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:31:44 -0500
Date: Sat, 18 Jan 2014 12:31:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
Message-ID: <20140118113143.GA2565@amd.pavel.ucw.cz>
References: <20140114162722.GF29865@pd.tnic>
 <20140117222806.GB13930@amd.pavel.ucw.cz>
 <20140117225013.GE14649@pd.tnic>
 <52D9B408.4020007@zytor.com>
 <20140118002926.GA22185@amd.pavel.ucw.cz>
 <52D9D6FC.7050100@zytor.com>
 <20140118020155.GA24158@amd.pavel.ucw.cz>
 <20140118104231.GA15466@pd.tnic>
 <20140118110829.GA2071@amd.pavel.ucw.cz>
 <20140118112620.GB15466@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140118112620.GB15466@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-01-18 12:26:20, Borislav Petkov wrote:
> On Sat, Jan 18, 2014 at 12:08:29PM +0100, Pavel Machek wrote:
> > ?? By the time userspace is booted, you have overwritten the MSR, and
> > information, if the BIOS is buggy, was lost.
> 
> Bullshit - if you don't apply the workaround, the bit in the MSR remains
> unset.

If you do not apply the workaround, you have the buggy system that may
or may not boot. There's even CVE for it.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
