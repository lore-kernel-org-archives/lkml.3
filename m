Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaANPfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:35:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48029 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaANPfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:35:40 -0500
Date: Tue, 14 Jan 2014 16:35:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: AMD errata 793 (CVE-2013-6885) needs a workaround in Linux?
Message-ID: <20140114153534.GE29865@pd.tnic>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D55468.6000000@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 07:14:48AM -0800, H. Peter Anvin wrote:
> Seriously, though, if this MSR can be set at runtime without problems
> (which covers 98% of all workarounds, but not 100%) then it seems
> like a no-brainer to just do it as long as the offending CPUs can be
> identified by the kernel.

Yeah, ok, let me cook it up.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
