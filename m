Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3LLUtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:49:17 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11965 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3LLUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:49:14 -0500
Message-ID: <1386881054.1791.316.camel@misato.fc.hp.com>
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org
Date: Thu, 12 Dec 2013 13:44:14 -0700
In-Reply-To: <20131212203533.GB26927@pd.tnic>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
	 <20131212002946.GF8863@pd.tnic>
	 <1386808323.1791.299.camel@misato.fc.hp.com>
	 <1386810484.1791.306.camel@misato.fc.hp.com>
	 <1386810620.1791.307.camel@misato.fc.hp.com>
	 <20131212162351.GA26927@pd.tnic>
	 <1386866583.1791.310.camel@misato.fc.hp.com>
	 <1386869221.1791.311.camel@misato.fc.hp.com>
	 <1386869777.1791.314.camel@misato.fc.hp.com>
	 <20131212203533.GB26927@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 21:35 +0100, Borislav Petkov wrote:
> On Thu, Dec 12, 2013 at 10:36:17AM -0700, Toshi Kani wrote:
> > BTW, the test system is shared and will be used by other test for a
> > couple of hours or so. So, please take your time. :-)
> 
> Yeah, ok :-)
> 
> I went and polished the debugging patch a bit more - it seems we're
> going to need it more often now, should probably send it up too :)
> 
> Right, so the pagetable dump shows that the new_memmap is not mapped in
> it, thus the #PF.
> 
> Ok, so next try: let's dump the pagetable after we've copied the pgd
> containing new_memmap. Same exercise as before, please.

Will do.

Thanks,
-Toshi


