Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaHMNVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:21:42 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:21829
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbaHMNVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:21:40 -0400
Date: Wed, 13 Aug 2014 15:21:29 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
        <linux-spi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] spi: xilinx: Remove .owner field for driver
References: <d35c656e50eb7cc951499f13ef339d6aa1a23deb.1407930755.git.michal.simek@xilinx.com>
 <20140813123343.GR17528@sirena.org.uk>
In-Reply-To: <20140813123343.GR17528@sirena.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="fNbvqeo5JA9pRX9lqDVIsH8MJji99pmRM"
X-RCIS-Action: ALLOW
Message-ID: <b172f93e-b2fb-4cf4-a2de-d2ca62cdb83f@BN1BFFO11FD016.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009004)(6009001)(438002)(51704005)(189002)(52044002)(164054003)(479174003)(24454002)(199003)(377454003)(44976005)(86362001)(81342001)(81542001)(92566001)(95666004)(107046002)(568964001)(6806004)(54356999)(99396002)(70736001)(85306004)(92726001)(76176999)(50986999)(4396001)(20776003)(46102001)(64706001)(1496007)(64126003)(71186001)(74502001)(87936001)(512944002)(74316001)(106466001)(102836001)(83072002)(85852003)(31696002)(31966008)(65956001)(83322001)(77982001)(19580405001)(76482001)(83506001)(84326002)(74662001)(104016003)(79102001)(80022001)(21056001)(33646002)(19580395003)(65826006)(142923001)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB008;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0302D4F392
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fNbvqeo5JA9pRX9lqDVIsH8MJji99pmRM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/13/2014 02:33 PM, Mark Brown wrote:
> On Wed, Aug 13, 2014 at 01:52:39PM +0200, Michal Simek wrote:
>> There is no need to init .owner field.
>>
>> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
>> "mmc: remove .owner field for drivers using module_platform_driver"
>>
>> This patch removes the superflous .owner field for drivers which
>> use the module_platform_driver API, as this is overriden in
>> platform_driver_register anyway."
>=20
> Would it not be better to do this as a tree wide or at least subsystem
> wide sweep with something like cocinelle?

Feel free to use cocinelle for fixing this everywhere.
For me was just easier to fix all xilinx drivers to ensure
that none else will copy it for new drivers.

Thanks,
Michal




--fNbvqeo5JA9pRX9lqDVIsH8MJji99pmRM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlPrZloACgkQykllyylKDCHKaQCeMyiabih/7wXIWOat2m26XP6k
HP8An2xwKezBcfPkTlCOVt4ioO2BSpVQ
=Pyw1
-----END PGP SIGNATURE-----

--fNbvqeo5JA9pRX9lqDVIsH8MJji99pmRM--
