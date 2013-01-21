Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3AUQFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:05:01 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:50934
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780Ab3AUQE7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:04:59 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z21eIz98dIc89bh1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz177df4h17326ah8275eha1495iz2dh668h839h947hd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MGZGO3-01-5R8-02
X-M-MSG: 
Date: Mon, 21 Jan 2013 10:04:50 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>,
        =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>,
        Udo van den Heuvel <udovdh@xs4all.nl>, <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
CC: <Suravee.Suthikulpanit@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130121160450.GA24792@jshin-Toonie>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
 <20130120111920.GL25591@8bytes.org>
 <50FBD413.1000406@xs4all.nl>
 <20130120114011.GN25591@8bytes.org>
 <20130120114828.GB16519@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20130120114828.GB16519@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:48:28PM +0100, Borislav Petkov wrote:
> On Sun, Jan 20, 2013 at 12:40:11PM +0100, Jörg Rödel wrote:
> > Yes, the BIOS vendor can fix this issue. They need to disable NB clock
> > gating for the IOMMU.
> 
> Right, Udo, you can try Gigabyte first.
> 
> Btw, can't we add a quirk to disable NB clock gating? Maybe Boris and
> Jacob could help. CCed.

Hi, yes we will try and reproduce the NB clock gating issue on our
end and submit a patch ASAP.

And Boris P., I think your IOAPIC not in IVRS issue we've also seen
something similar recently (on Xen), so we'll atempt to tackle that
one too afterwards.

-Jacob

> 
> Guys, the error description is at
> http://marc.info/?l=linux-kernel&m=135867802432660
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

