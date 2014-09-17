Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaIQROM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:14:12 -0400
Received: from mail-by2on0128.outbound.protection.outlook.com ([207.46.100.128]:47040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756019AbaIQROK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:14:10 -0400
Message-ID: <1410972043.24184.532.camel@snotra.buserror.net>
Subject: Re: [PATCH v3 00/21] powerpc/8xx: Optimise MMU TLB handling and add
 support of 16k pages
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 17 Sep 2014 11:40:43 -0500
In-Reply-To: <20140917163656.E09D81AB026@localhost.localdomain>
References: <20140917163656.E09D81AB026@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:6969:ddc5:bfaf:5d2e]
X-ClientProxiedBy: CY1PR0601CA0036.namprd06.prod.outlook.com (25.160.162.46)
 To BY2PR0301MB0726.namprd03.prod.outlook.com (25.160.63.16)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377424004)(189002)(199003)(24454002)(110136001)(83322001)(106356001)(76176999)(83072002)(19580405001)(93916002)(47776003)(92726001)(85852003)(104166001)(102836001)(33646002)(105586002)(97736003)(23676002)(101416001)(64706001)(95666004)(86362001)(89996001)(79102003)(21056001)(92566001)(62966002)(50226001)(31966008)(77982003)(103116003)(87286001)(87976001)(46102003)(77156001)(80022003)(4396001)(77096002)(99396002)(88136002)(50466002)(76482002)(81542003)(74502003)(50986999)(107046002)(20776003)(42186005)(85306004)(81342003)(3826002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0726;H:[IPv6:2601:2:5800:3f7:6969:ddc5:bfaf:5d2e];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-17 at 18:36 +0200, Christophe Leroy wrote:
> This patchset:
> 1) provides several MMU TLB handling optimisation on MPC8xx.
> 2) adds support of 16k pages on MPC8xx.
> All changes have been successfully tested on a custom board equipped with MPC885
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

I've already applied patches 1, 2, 4, 5, 6, 9, and 10 from the previous
patchset -- have they changed?

-Scott


