Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaARL0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:26:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37114 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaARL0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:26:31 -0500
Date: Sat, 18 Jan 2014 12:26:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum 793
Message-ID: <20140118112620.GB15466@pd.tnic>
References: <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <20140117222806.GB13930@amd.pavel.ucw.cz>
 <20140117225013.GE14649@pd.tnic>
 <52D9B408.4020007@zytor.com>
 <20140118002926.GA22185@amd.pavel.ucw.cz>
 <52D9D6FC.7050100@zytor.com>
 <20140118020155.GA24158@amd.pavel.ucw.cz>
 <20140118104231.GA15466@pd.tnic>
 <20140118110829.GA2071@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140118110829.GA2071@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 12:08:29PM +0100, Pavel Machek wrote:
> ?? By the time userspace is booted, you have overwritten the MSR, and
> information, if the BIOS is buggy, was lost.

Bullshit - if you don't apply the workaround, the bit in the MSR remains
unset.

Drop this senseless conversation and go play with something else. At
least I am.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
