Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3AUWgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:36:50 -0500
Received: from [65.55.88.15] ([65.55.88.15]:22617 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab3AUWgs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:36:48 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z21eIz98dIc89bh936eI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz177df4h17326ah8275eha1495iz2dh668h839h93fhd24hd2bhf0ah10d2h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1537h162dh1631h1758h1898h18e1h1155h)
X-WSS-ID: 0MGZYQM-02-28Q-02
X-M-MSG: 
Message-ID: <1358807712.2812.2.camel@Greyghost-ubuntu>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reply-To: <suravee.suthikulpanit@amd.com>
To: Jacob Shin <jacob.shin@amd.com>
CC: Borislav Petkov <bp@alien8.de>,
        =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>,
        Udo van den Heuvel <udovdh@xs4all.nl>, <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Date: Mon, 21 Jan 2013 16:35:12 -0600
In-Reply-To: <20130121160450.GA24792@jshin-Toonie>
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic>
	 <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>
	 <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org>
	 <20130120114828.GB16519@pd.tnic> <20130121160450.GA24792@jshin-Toonie>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo, 

I am trying to debug the issue but need to check one thing on your
system.  Would you please try the following and check the output value
on your system?

# setpci -s 00:00.02 F0.w=90
# setpci -s 00:00.02 F4.w


Thank you,

Suravee


On Mon, 2013-01-21 at 10:04 -0600, Jacob Shin wrote:
> On Sun, Jan 20, 2013 at 12:48:28PM +0100, Borislav Petkov wrote:
> > On Sun, Jan 20, 2013 at 12:40:11PM +0100, Jörg Rödel wrote:
> > > Yes, the BIOS vendor can fix this issue. They need to disable NB clock
> > > gating for the IOMMU.
> > 
> > Right, Udo, you can try Gigabyte first.
> > 
> > Btw, can't we add a quirk to disable NB clock gating? Maybe Boris and
> > Jacob could help. CCed.
> 
> Hi, yes we will try and reproduce the NB clock gating issue on our
> end and submit a patch ASAP.
> 
> And Boris P., I think your IOAPIC not in IVRS issue we've also seen
> something similar recently (on Xen), so we'll atempt to tackle that
> one too afterwards.
> 
> -Jacob
> 
> > 
> > Guys, the error description is at
> > http://marc.info/?l=linux-kernel&m=135867802432660
> > 
> > Thanks.
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > Sent from a fat crate under my desk. Formatting is fine.
> > --
> > 



