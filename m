Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaIYUmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:42:08 -0400
Received: from mail-bl2on0132.outbound.protection.outlook.com ([65.55.169.132]:11667
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751318AbaIYUmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:42:06 -0400
Message-ID: <1411677716.13320.206.camel@snotra.buserror.net>
Subject: Re: [PATCH 2/3] qe_common: add qe common functions to qe_common.c
From: Scott Wood <scottwood@freescale.com>
To: Zhao Qiang <B45475@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <B07421@freescale.com>, <R63061@freescale.com>
Date: Thu, 25 Sep 2014 15:41:56 -0500
In-Reply-To: <1411613237-2271-1-git-send-email-B45475@freescale.com>
References: <1411613237-2271-1-git-send-email-B45475@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:416f:c6f:49e6:9e61]
X-ClientProxiedBy: BN1PR08CA0017.namprd08.prod.outlook.com (10.242.217.145) To
 BN1PR0301MB0722.namprd03.prod.outlook.com (25.160.78.141)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0722;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(51704005)(189002)(377424004)(92726001)(93916002)(87976001)(92566001)(50226001)(102836001)(97736003)(86362001)(103116003)(89996001)(110136001)(99396003)(77156001)(76176999)(50986999)(104166001)(87286001)(77096002)(23676002)(33646002)(88136002)(105586002)(4396001)(76482002)(50466002)(101416001)(19580405001)(47776003)(106356001)(107046002)(120916001)(10300001)(62966002)(20776003)(64706001)(80022003)(79102003)(81542003)(21056001)(31966008)(46102003)(77982003)(90102001)(74502003)(85306004)(95666004)(74662003)(81342003)(42186005)(19580395003)(83322001)(85852003)(83072002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0722;H:[IPv6:2601:2:5800:3f7:416f:c6f:49e6:9e61];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 10:47 +0800, Zhao Qiang wrote:
> qe need to call some common functions, move them into
> public directory, add a new file drivers/soc/qe/qe_common.c
> for them.
> 
> Signed-off-by: Zhao Qiang <B45475@freescale.com>
> ---
>  drivers/soc/qe/Makefile    |   2 +-
>  drivers/soc/qe/qe_common.c | 185 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fsl/qe.h     |  52 +++++++++++--
>  3 files changed, 230 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/soc/qe/qe_common.c

I see code being copied, not moved.

Where is patch 1/3?

-Scott


