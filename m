Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaAQSZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:25:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39187 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbaAQSZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:25:38 -0500
Date: Fri, 17 Jan 2014 19:25:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum 793
Message-ID: <20140117182528.GK8715@pd.tnic>
References: <20140114162722.GF29865@pd.tnic>
 <52D59ACC.3090100@amd.com>
 <20140114203848.GP29865@pd.tnic>
 <52D81DB5.7000608@amd.com>
 <20140117002123.GA9165@khazad-dum.debian.net>
 <20140117101842.GB8715@pd.tnic>
 <52D958FC.9020700@zytor.com>
 <20140117170213.GG8715@pd.tnic>
 <52D96B9D.703@zytor.com>
 <52D970F1.3090401@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D970F1.3090401@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 12:05:37PM -0600, Aravind Gopalakrishnan wrote:
> On 1/17/2014 11:42 AM, H. Peter Anvin wrote:
> >
> >Hence the question: did an unfixed BIOS ever make it into a shipping
> >production system?  Because if it did, we do have a coverage hole.
> >
> Right, and the answer to your question is: there is a *chance* it
> did.. From internal discussions, I could gather that the fix went into
> BIOS code earlier for desktop/mobile versions than it did for server
> versions;
>
> So there is a chance production systems (desktop ones) might never see
> the issue, but server ones will, as BIOSes spun only from now onwards
> will have the workaround..

This is exactly what I mean: I would like to have this question answered
before any erratum fix goes into the kernel.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
