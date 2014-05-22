Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaEVWyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:54:13 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:52112
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751145AbaEVWyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:54:12 -0400
Date: Thu, 22 May 2014 17:37:58 -0500
From: Scott Wood <scottwood@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: powerpc: remove checks for CONFIG_BOOK3E_MMU_TLB_STATS
Message-ID: <20140522223758.GA20343@home.buserror.net>
References: <1400608550.4912.48.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1400608550.4912.48.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [2601:2:5800:3f7:94a7:3934:a2c9:ca27]
X-ClientProxiedBy: DM2PR04CA054.namprd04.prod.outlook.com (10.141.154.172)
 To DM2PR03MB400.namprd03.prod.outlook.com (10.141.84.153)
X-Forefront-PRVS: 021975AE46
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(189002)(199002)(24454002)(42186004)(83322001)(19580405001)(20776003)(47776003)(23726002)(80022001)(99396002)(33656002)(83072002)(46102001)(92566001)(50986999)(54356999)(19580395003)(53416003)(46406003)(76176999)(76482001)(83506001)(79102001)(86362001)(64706001)(81342001)(74662001)(102836001)(31966008)(74502001)(4396001)(81542001)(81156002)(87976001)(101416001)(85852003)(77982001)(97756001)(21056001)(69596002)(50466002)(92726001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB400;H:home.buserror.net;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 07:55:50PM +0200, Paul Bolle wrote:
> Three checks for CONFIG_BOOK3E_MMU_TLB_STATS were added in v2.6.32. But
> the related Kconfig symbol was never added. These checks have always
> evaluated to false. Remove them.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> ---
> Untested.
> 
> A second order cleanup is now possible (ie, TLB_MISS_PROLOG_STATS and
> friends are, well, defined away). Perhaps it is preferable to include
> that cleanup in this patch.
> 
>  arch/powerpc/include/asm/exception-64e.h | 38 --------------------------------
>  arch/powerpc/mm/tlb_low_64e.S            | 10 ---------
>  2 files changed, 48 deletions(-)

/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S: Assembler messages:
/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:89: Error: unrecognized opcode: `tlb_miss_prolog_stats'
/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:238: Error: unrecognized opcode: `tlb_miss_prolog_stats'
/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:269: Error: unrecognized opcode: `tlb_miss_prolog_stats'
/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:281: Error: unrecognized opcode: `tlb_miss_prolog_stats'
/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:441: Error: unrecognized opcode: `tlb_miss_prolog_stats'
/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:510: Error: unrecognized opcode: `tlb_miss_prolog_stats'
/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:881: Error: unrecognized opcode: `tlb_miss_prolog_stats'
/home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:918: Error: unrecognized opcode: `tlb_miss_prolog_stats'

-Scott
