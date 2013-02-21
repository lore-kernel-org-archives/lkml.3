Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3BUKeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:34:25 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35793 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724Ab3BUKeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:34:06 -0500
Date: Thu, 21 Feb 2013 10:33:43 +0000
From: Will Deacon <will.deacon@arm.com>
To: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
Message-ID: <20130221103342.GA20566@mudshark.cambridge.arm.com>
References: <5112DC7E.4020108@dawncrow.de>
 <20130206225150.GL17833@n2100.arm.linux.org.uk>
 <5112E0C3.1080706@dawncrow.de>
 <20130208154809.GF3495@mudshark.cambridge.arm.com>
 <511A4B93.1000700@dawncrow.de>
 <20130212140950.GC4123@mudshark.cambridge.arm.com>
 <511A5995.5000607@parrot.com>
 <5125254D.7040401@dawncrow.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5125254D.7040401@dawncrow.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andre,

On Wed, Feb 20, 2013 at 07:34:37PM +0000, André Hentschel wrote:
> Am 12.02.2013 16:02, schrieb Matthieu CASTET:
> > The tls value is never saved to : thread->tp_value[1].
> > 
> > Also I don't know if you can avoid the extra ldr in the software case.
>
> seems like Matthieu is right, any update on this?

Yeah, I'll get round to this after the merge window and send a v2.
I have a nice long flight to Hong Kong on the horizon, which may well drive
me to writing patches :)

Cheers,

Will
