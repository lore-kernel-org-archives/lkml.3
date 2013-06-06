Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3FFUo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:44:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45613 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab3FFUo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:44:27 -0400
Date: Thu, 6 Jun 2013 22:44:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Message-ID: <20130606204410.GQ20972@pd.tnic>
References: <20130606132603.GD20972@pd.tnic>
 <20130606175052.GA1285@srcf.ucam.org>
 <20130606185140.GK20972@pd.tnic>
 <20130606193548.GA2946@srcf.ucam.org>
 <20130606194134.GN20972@pd.tnic>
 <20130606195450.GA3252@srcf.ucam.org>
 <20130606200705.GO20972@pd.tnic>
 <20130606201828.GA3950@srcf.ucam.org>
 <20130606202717.GP20972@pd.tnic>
 <20130606203057.GA4237@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130606203057.GA4237@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 09:30:57PM +0100, Matthew Garrett wrote:
> Well, we want the 1:1 mappings to exist all the time. The only
> thing the option should change is whether they're passed to
> SetVirtualAddressMap() or not.

But can you call them even if they haven't been passed through
SetVirtualAddressMap, *after* SetVirtualAddressMap has been called?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
