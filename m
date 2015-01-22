Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbbAVKPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:15:07 -0500
Received: from mail-db3on0057.outbound.protection.outlook.com ([157.55.234.57]:38464
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751648AbbAVKO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:14:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
From: Andri Yngvason <andri.yngvason@marel.com>
In-Reply-To: <54C02F4B.80206@pengutronix.de>
CC: Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20141223154654.GB6460@vivalin-002> <20150120214409.GA16828@linux>
 <20150120214537.GB16828@linux> <20150121162025.2933.13836@shannon>
 <54C02F4B.80206@pengutronix.de>
Message-ID: <20150122101447.25198.24222@shannon>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 2/5] can: kvaser_usb: Consolidate and unify state change
 handling
Date: Thu, 22 Jan 2015 10:14:47 +0000
X-Originating-IP: [10.100.11.118]
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 212.30.206.5)
 smtp.mailfrom=Andri.Yngvason@marel.com; 
X-Forefront-Antispam-Report: CIP:212.30.206.5;CTRY:IS;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(377424004)(377454003)(189002)(199003)(479174004)(41574002)(24454002)(106466001)(23676002)(76176999)(54356999)(50986999)(6806004)(46102003)(77096005)(57986006)(76506005)(77156002)(93886004)(62966003)(2950100001)(88526003)(86362001)(50466002)(87936001)(92566002)(33716001)(64706001)(47776003)(16796002)(83506001)(71226002)(69266003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR05MB0604;H:smtp.marel.com;FPR:;SPF:Pass;MLV:sfv;PTR:smtp.marel.com;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DB3PR05MB0604;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB3PR05MB0604;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB0604;
X-OriginatorOrg: marel.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 10:14:54.8955
 (UTC)
X-MS-Exchange-CrossTenant-Id: e5f498be-7303-45fd-a594-9e3fd22a77d7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5f498be-7303-45fd-a594-9e3fd22a77d7;Ip=[212.30.206.5]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR05MB0604
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Marc Kleine-Budde (2015-01-21 22:59:23)
> On 01/21/2015 05:20 PM, Andri Yngvason wrote:
> > Marc, could you merge the "move bus_off++" patch before you merge this so that I
> > won't have to incorporate this patch-set into it?
> 
> ...included in the lastest pull-request to David. Use
> tags/linux-can-next-for-3.20-20150121 of the can-next repo as you new base.
> 

Thanks!

--
Andri
