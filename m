Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3CFVFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:05:05 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:41500 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3CFVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:05:03 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AttrACWvN1FV5qjOPGdsb2JhbABEjFy3WAMBgVwXAwEBAQE4NIIrAQEFOhwTAQ8QCAMUBAklDwUlChoTiBe8HhWNK0uBAQeCX2EDlkqGCI1z
X-IronPort-AV: E=Sophos;i="4.84,798,1355094000"; 
   d="scan'208";a="508680461"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Mar 2013 22:07:41 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 3.9-rc1
Message-ID: <20130306210741.GA366@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
 <20130306080642.GA535@polaris.bitmath.org>
 <CA+55aFxkDRoNEEw+8RwrSCsRUCUcRbEE57hzFQ8dPUXT2CWMog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxkDRoNEEw+8RwrSCsRUCUcRbEE57hzFQ8dPUXT2CWMog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 08:08:34AM -0800, Linus Torvalds wrote:
> On Wed, Mar 6, 2013 at 12:06 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >
> > Or not. ;-) This commit breaks boot on my MacBookAir3,1:
> >
> > commit 8d57470d8f859635deffe3919d7d4867b488b85a
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Fri Nov 16 19:38:58 2012 -0800
> >
> >     x86, mm: setup page table in top-down
> 
> Argh. The whole page table setup crud is scarily fragile.
> 
> > Being a 64-bit apple-EFI machine, it probably runs through an obscure
> > path in this patch. I wish I had more vital information, but I get the
> > white screen of death, so not much to go on so far.
> 
> I actually test on my MBA (also EFI boot), but it's a slightly newer
> 4,1 version, and the memory map looks very different (I've got 251
> memory regions reported by efi, ugh).
> 
> So Apple EFI does work at least in some cases, just not yours. Let's
> hope Yinghai can figure this one out..

And so he did, thanks! FWIW, I also hit the ACPI problem. I have not
seen it often enough to register anything.

Cheers,
Henrik
