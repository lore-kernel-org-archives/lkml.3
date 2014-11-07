Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaKGDvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 22:51:43 -0500
Received: from mail-bl2on0102.outbound.protection.outlook.com ([65.55.169.102]:41896
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751249AbaKGDvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 22:51:41 -0500
Date: Thu, 6 Nov 2014 21:50:08 -0600
From: Scott Wood <scottwood@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Vitaly Bordug <vitb@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: powerpc/8xx: Remove Kconfig symbol FADS
Message-ID: <20141107035008.GA25204@home.buserror.net>
References: <1411545979.19525.5.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411545979.19525.5.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [2601:2:5800:3f7:5c04:72f8:a6ec:82b5]
X-ClientProxiedBy: BLUPR08CA0032.namprd08.prod.outlook.com (10.141.200.12) To
 DM2PR0301MB0735.namprd03.prod.outlook.com (25.160.97.143)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0735;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(51704005)(189002)(19580405001)(87976001)(54356999)(120916001)(76176999)(42186005)(50466002)(110136001)(46406003)(83506001)(86362001)(95666004)(69596002)(19580395003)(50986999)(33656002)(77096003)(46102003)(101416001)(97756001)(31966008)(97736003)(21056001)(64706001)(106356001)(105586002)(20776003)(122386002)(77156002)(99396003)(53416004)(92566001)(81156004)(23726002)(47776003)(102836001)(107046002)(40100003)(92726001)(62966003)(4396001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0735;H:home.buserror.net;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:06:19AM +0200, Paul Bolle wrote:
> Commit 39eb56da2b53 ("pcmcia: Remove m8xx_pcmcia driver") removed the
> only driver that used CONFIG_FADS. Setting the Kconfig symbol FADS is
> pointless since that commit. Remove it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Done on top of next-20140923. Tested with "git grep" only.
> 
> Another cleanup might be to remove MPC8XXFADS (or "FADS") from the "8xx
> Machine Type" choice. Is there any reason left to pick "FADS" as a
> machine type?

Nothing references MPC8XXFADS, so yes, it can be removed.

-Scott
