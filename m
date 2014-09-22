Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaIVQ6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:58:44 -0400
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:48544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753542AbaIVQ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:58:43 -0400
Date: Mon, 22 Sep 2014 11:53:28 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: "J. German Rivera" <German.Rivera@freescale.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 0/3 v2] drivers/bus: Freescale Management Complex bus
 driver patch series
Message-ID: <20140922115328.7d6fa30635ed52de425f9ebc@freescale.com>
In-Reply-To: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(164054003)(199003)(51704005)(189002)(105606002)(110136001)(31966008)(77982003)(81542003)(4396001)(81342003)(50226001)(50466002)(19580395003)(62966002)(92566001)(83072002)(68736004)(74662003)(86362001)(46102003)(69596002)(97736003)(100306002)(74502003)(76482002)(85852003)(19580405001)(79102003)(120916001)(83322001)(93916002)(95666004)(6806004)(44976005)(21056001)(80022003)(92726001)(104016003)(87936001)(33646002)(46406003)(90102001)(89996001)(88136002)(77156001)(26826002)(85306004)(104166001)(81156004)(87286001)(106466001)(36756003)(76176999)(20776003)(107046002)(84676001)(64706001)(102836001)(50986999)(47776003)(99396002)(23726002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0739;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0739;
X-Forefront-PRVS: 034215E98F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 17:49:38 -0500
"J. German Rivera" <German.Rivera@freescale.com> wrote:

> CHANGE HISTORY
> 
> Issues pending resolution not addressed by v2:
> - What to do with Doxygen comments in patch 1

It's clear they should be removed.

> - Whether to move or not FSL-specific header files added in include/linux,
>   by this patch series, to another location

there wasn't a valid objection against moving them under fsl/ and
changing them to use dashes instead of underscores, was there?

> - Whether to change or not the wording of the licenses used in some
>   source files

I agree with Alex to use the existing kernel versions, to be on
the safe side, but IANAL - did you want to go to the source of the
change (presumably a lawyer?) and find out why the contributors
clause was omitted and how they think that's appropriate in an
upstream submission?  If not, please resubmit after converting all
files to use the existing common kernel license text.

Thanks,

Kim
