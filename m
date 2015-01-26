Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbbAZKxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:53:06 -0500
Received: from mail-db3on0084.outbound.protection.outlook.com ([157.55.234.84]:52304
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752114AbbAZKxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:53:02 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
From: Andri Yngvason <andri.yngvason@marel.com>
In-Reply-To: <54C61BE4.8070105@pengutronix.de>
CC: Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20141223154654.GB6460@vivalin-002>
 <20150126051755.GA3014@Darwish.PC> <20150126052039.GB3014@Darwish.PC>
 <20150126052254.GC3014@Darwish.PC> <20150126052406.GD3014@Darwish.PC>
 <20150126052543.GE3014@Darwish.PC> <20150126052719.GF3014@Darwish.PC>
 <20150126102843.17894.84372@shannon> <54C61BE4.8070105@pengutronix.de>
Message-ID: <20150126105250.19943.75012@shannon>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v6 5/7] can: kvaser_usb: Update interface state before exiting on
 OOM
Date: Mon, 26 Jan 2015 10:52:50 +0000
X-Originating-IP: [10.100.11.118]
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 212.30.206.5)
 smtp.mailfrom=Andri.Yngvason@marel.com; pengutronix.de; dkim=none (message
 not signed) header.d=none;pengutronix.de; dmarc=permerror action=none
 header.from=marel.com;
X-Forefront-Antispam-Report: CIP:212.30.206.5;CTRY:IS;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(479174004)(377424004)(24454002)(377454003)(6806004)(46102003)(71226002)(77096005)(88526003)(19580405001)(19580395003)(93886004)(86362001)(106466001)(16796002)(87936001)(50466002)(77156002)(62966003)(33716001)(23676002)(2950100001)(54356999)(76176999)(50986999)(57986006)(92566002)(47776003)(76506005)(69266003);DIR:OUT;SFP:1101;SCL:1;SRVR:AMSPR05MB245;H:smtp.marel.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:AMSPR05MB245;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AMSPR05MB245;
X-Forefront-PRVS: 0468FE4A2B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB245;
X-OriginatorOrg: marel.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2015 10:52:58.6817
 (UTC)
X-MS-Exchange-CrossTenant-Id: e5f498be-7303-45fd-a594-9e3fd22a77d7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5f498be-7303-45fd-a594-9e3fd22a77d7;Ip=[212.30.206.5]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMSPR05MB245
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Marc Kleine-Budde (2015-01-26 10:50:12)
> On 01/26/2015 11:28 AM, Andri Yngvason wrote:
> > Quoting Ahmed S. Darwish (2015-01-26 05:27:19)
> >> From: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> >>
> >> Update all of the can interface's state and error counters before
> >> trying any skb allocation that can actually fail with -ENOMEM.
> >>
> >> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >> Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> >> ---
> >>  drivers/net/can/usb/kvaser_usb.c |  181 ++++++++++++++++++++++----------------
> >>  1 files changed, 105 insertions(+), 76 deletions(-)
> [..]
> 
> > Looks good to me.
> 
> Can I add your Acked-by to 5-7?
> 
Yes.

--
Andri
