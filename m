Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbbAULAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:00:17 -0500
Received: from mail-db3on0090.outbound.protection.outlook.com ([157.55.234.90]:10304
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916AbbAULAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:00:11 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
From: Andri Yngvason <andri.yngvason@marel.com>
In-Reply-To: <54BF8326.3080406@pengutronix.de>
CC: Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20141223154654.GB6460@vivalin-002> <20150120214409.GA16828@linux>
 <20150120214537.GB16828@linux> <20150121103319.14511.57709@shannon>
 <54BF8326.3080406@pengutronix.de>
Message-ID: <20150121110002.18486.29514@shannon>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 2/5] can: kvaser_usb: Consolidate and unify state change
 handling
Date: Wed, 21 Jan 2015 11:00:02 +0000
X-Originating-IP: [10.100.11.118]
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 212.30.206.5)
 smtp.mailfrom=Andri.Yngvason@marel.com; 
X-Forefront-Antispam-Report: CIP:212.30.206.5;CTRY:IS;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(51704005)(377424004)(189002)(479174004)(199003)(24454002)(6806004)(50986999)(92566002)(76506005)(46102003)(106466001)(71226002)(54356999)(76176999)(86362001)(19580405001)(19580395003)(2950100001)(88526003)(87936001)(62966003)(57986006)(77156002)(83506001)(33716001)(77096005)(47776003)(64706001)(50466002)(93886004)(16796002)(23676002)(69266003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR05MB249;H:smtp.marel.com;FPR:;SPF:Pass;MLV:sfv;PTR:smtp.marel.com;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DB3PR05MB249;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB3PR05MB249;
X-Forefront-PRVS: 04631F8F77
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB249;
X-OriginatorOrg: marel.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 11:00:08.5714
 (UTC)
X-MS-Exchange-CrossTenant-Id: e5f498be-7303-45fd-a594-9e3fd22a77d7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5f498be-7303-45fd-a594-9e3fd22a77d7;Ip=[212.30.206.5]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR05MB249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Marc Kleine-Budde (2015-01-21 10:44:54)
> On 01/21/2015 11:33 AM, Andri Yngvason wrote:
> > Quoting Ahmed S. Darwish (2015-01-20 21:45:37)
> >> From: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> >>
> >> Replace most of the can interface's state and error counters
> >> handling with the new can-dev can_change_state() mechanism.
> >>
> >> Suggested-by: Andri Yngvason <andri.yngvason@marel.com>
> >> Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> >> ---
> >>  drivers/net/can/usb/kvaser_usb.c | 114 +++++++++++++++++++--------------------
> >>  1 file changed, 55 insertions(+), 59 deletions(-)
> >>
> >> diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
> >> index 971c5f9..0386d3f 100644
> >> --- a/drivers/net/can/usb/kvaser_usb.c
> >> +++ b/drivers/net/can/usb/kvaser_usb.c
> 
> > Looks good.
> 
> Is this an Acked-by?
> 

ACK.

--
Andri
