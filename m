Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3CHKl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:41:28 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:13094
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016Ab3CHKl0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:41:26 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1362739279.2201.3.camel@leyfoon-vm>
Subject: Re: [PATCH 1/1] drivers/misc: Add Altera System ID driver
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Date: Fri, 8 Mar 2013 18:41:19 +0800
In-Reply-To: <201303052159.36531.arnd@arndb.de>
References: <1362366697-2768-1-git-send-email-lftan@altera.com>
	 <201303041255.42142.arnd@arndb.de> <1362481947.2293.11.camel@leyfoon-vm>
	 <201303052159.36531.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 21:59 +0000, Arnd Bergmann wrote:
> On Tuesday 05 March 2013, Ley Foon Tan wrote:
> > The sysid give the unique system ID and system generation timestamp of
> > the system.
> > 
> > CASE 1:
> > SOCFPGA SoC + Sysid component in FPGA
> > 
> > CASE 2
> > Nios II soft core CPU + Sysid  (All in FPGA and no SoC is involved)
> > 
> > From example use cases above, Case 2 doesn't involve SoC component. 
> > To support both cases, do you think drivers/base/soc.c is still
> > suitable?
> 
> Yes, I think so. I would consider the second case still a SoC, because
> you have a single chip that contains the CPU and peripherals. From
> the OS point of view, it does not matter that they are in an FPGA.
> 
> 	Arnd

Thanks for your input. I will go with your suggestion.

LFTan


