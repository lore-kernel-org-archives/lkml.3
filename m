Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3FRAM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:12:26 -0400
Received: from [213.199.154.187] ([213.199.154.187]:52699 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab3FRAMX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:12:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Mon, 17 Jun 2013 19:10:53 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v2] powerpc/pci: Fix setup of Freescale PCI / PCIe
 controllers
To: Rojhalat Ibrahim <imr@rtschenk.de>
CC: Michael Guntsche <michael.guntsche@it-loops.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
References: <1371241083.2996.7@snotra> <2435509.QyTW5GJC53@pcimr>
In-Reply-To: <2435509.QyTW5GJC53@pcimr> (from imr@rtschenk.de on Mon Jun 17
	08:15:33 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1371514253.9073.8@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 08:15:33 AM, Rojhalat Ibrahim wrote:
> On Friday 14 June 2013 15:18:03 Scott Wood wrote:
> > On 83xx:
> > cc1: warnings being treated as errors
> >  
> /home/scott/fsl/git/linux/upstream/arch/powerpc/sysdev/fsl_pci.c:100:23:
> > error: 'fsl_indirect_pcie_ops' defined but not used
> > make[2]: *** [arch/powerpc/sysdev/fsl_pci.o] Error 1
> > make[2]: *** Waiting for unfinished jobs....
> >
> > I can fix this when applying, but this makes me wonder how you  
> tested
> > it, given that the whole point is to fix 83xx...  Did you fix this  
> and
> > then accidentally sent a stale version?
> >
> > Also, please be careful that the patch doesn't get line wrapped -- I
> > had to manually unwrap a couple places.  Use git send-email if you
> > can't get KMail to cooperate.
> >
> > -Scott
> 
> Sorry about the mess. I'll send a v3.
> Please note: I don't have an 83xx system. So I can only test if it  
> compiles,
> which I obviously did not do with the right config.

OK, so it looks like it was Michael who ran into the problem on 83xx.   
Michael, could you test the v3 patch that Rojhalat posted?

-Scott
