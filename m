Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab3BLOKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:10:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56285 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab3BLOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:10:10 -0500
Date: Tue, 12 Feb 2013 14:09:51 +0000
From: Will Deacon <will.deacon@arm.com>
To: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
Message-ID: <20130212140950.GC4123@mudshark.cambridge.arm.com>
References: <5112DC7E.4020108@dawncrow.de>
 <20130206225150.GL17833@n2100.arm.linux.org.uk>
 <5112E0C3.1080706@dawncrow.de>
 <20130208154809.GF3495@mudshark.cambridge.arm.com>
 <511A4B93.1000700@dawncrow.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <511A4B93.1000700@dawncrow.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andre,

On Tue, Feb 12, 2013 at 02:02:59PM +0000, André Hentschel wrote:
> Am 08.02.2013 16:48, schrieb Will Deacon:
> > On Wed, Feb 06, 2013 at 11:01:23PM +0000, André Hentschel wrote:
> >> No, i'm not sure how to improve this. How does the process can continue, can you or someone else fix that and add his Signed-off-by?
> > 
> > How about something like the (completely untested) diff below?
> > 
> > Andre: if this works for you, I'm happy to write a commit message etc.
> 
> Thx for your effort, but it doesn't work, at least not with my 3.4.6 suse kernel.
> Be free to have another try, i'll be happy to test it.

Well, cheers for testing. Can you be more specific about what goes wrong
please? What do you see in TPIDRURW?

Will
