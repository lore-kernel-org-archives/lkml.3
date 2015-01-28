Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbbA1UzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:55:00 -0500
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:53584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753931AbbA1Uyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:54 -0500
Date: Wed, 28 Jan 2015 15:21:19 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] ARM: zynq: Remove bogus value from 'bias-disable'
 property
References: <1422301796-22888-1-git-send-email-soren.brinkmann@xilinx.com>
 <54C6DDE8.3000905@suse.de>
In-Reply-To: <54C6DDE8.3000905@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Of3Md1kDMWwojpwvIlFLKVqWoDU8k6HtX"
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21288.007
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <ce6e56872ab744a49612ef9bca07c73d@BN1AFFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; suse.de; dkim=none (message not
 signed) header.d=none;
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(377454003)(164054003)(479174004)(24454002)(51704005)(512874002)(92566002)(6806004)(19580395003)(64126003)(76176999)(106466001)(84326002)(74316001)(92726002)(65806001)(54356999)(86362001)(19580405001)(46102003)(77156002)(77096005)(2950100001)(568964001)(33646002)(108616004)(65956001)(83506001)(87936001)(62966003)(50986999)(104016003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB020;H:xir-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB020;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1AFFO11HUB020;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB020;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 14:21:36.7512
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1AFFO11HUB020
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Of3Md1kDMWwojpwvIlFLKVqWoDU8k6HtX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/27/2015 01:38 AM, Andreas F=C3=A4rber wrote:
> Am 26.01.2015 um 20:49 schrieb Soren Brinkmann:
>> In one pinctrl node, a 'bias-disable' property is erroneously assigned=
 a
>> value.
>>
>> Fixes: ARM: zynq: DT: Add pinctrl information
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>=20
> Reviewed-by: Andreas F=C3=A4rber <afaerber@suse.de>
>=20
> Andreas
>=20

Applied both.

Thanks,
Michal


--Of3Md1kDMWwojpwvIlFLKVqWoDU8k6HtX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlTI8GMACgkQykllyylKDCHOvgCfbuar5AsiJInFpFDpFKWmS2/o
ao0AoIrnqImPrQk7T3HaPUuvPq6lfq7p
=ufXe
-----END PGP SIGNATURE-----

--Of3Md1kDMWwojpwvIlFLKVqWoDU8k6HtX--
