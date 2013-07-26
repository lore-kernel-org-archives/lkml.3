Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3GZHfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:35:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39987 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab3GZHfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:35:43 -0400
Message-ID: <51F226C2.9000206@ti.com>
Date: Fri, 26 Jul 2013 10:35:30 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] video: xilinxfb: Fix compilation warning
References: <b8701d73538d37495b41ef465440a6d5f3018870.1374759923.git.michal.simek@xilinx.com> <51F2262F.1020203@ti.com>
In-Reply-To: <51F2262F.1020203@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="EnWmfqINw3pxcJoC2x2Q7tO0TLBvKK2WT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EnWmfqINw3pxcJoC2x2Q7tO0TLBvKK2WT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26/07/13 10:33, Tomi Valkeinen wrote:
> On 25/07/13 16:45, Michal Simek wrote:
>> regs_phys is phys_addr_t (u32 or u64).
>> Lets use %pa printk format specifier.
>>
>> Fixes compilation warning introduced by:
>> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
>> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

> Thanks, I've applied this into my 3.12/fbdev branch.

Actually, let's put this into 3.11-fixes/fbdev branch.

 Tomi



--EnWmfqINw3pxcJoC2x2Q7tO0TLBvKK2WT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8ibCAAoJEPo9qoy8lh71yp8QAILiKFtaKgYxVeJwXLu6/Gs/
8ozrxCUSN1gt0gxE9V7IJvvcUjKJmz/hPpLKnX8z4iRX87u/S/jTMa+dN0yFqPLq
tqzQDbHdZu/hZQ1w+yzZCC7howmZzqtt4IXUgbwbCUiJBv1du7vDRDIwnR2uy6lG
4tfX9ebcax6S+tmqLyCtGwVjGvJ/oWfRWYKGbs8n7aNvzo8uUTdNHUlwHqm2hObF
69BkEawdTcYZXRPsTkJOkK2zl5S2kok+szj7AfTDBXWNO9PRSMo3yMWjiev7nCni
SOM2+ezcRtKVGD6NphcD5lF4vrqwm+ugj9yUCXRdVp1yCZdYGxtItX7UO2ZCt8Cf
AgGyDIXZsGr14hnVftS9RkWsNiy5RjKK+dv+U/LMQ4AUaBZ6c7Du+gUJR1vsSuaR
G4w1dm2JmFrZpcLNL94wOO388Pain/SYxa1rNswXDIuEXcAwa1PUKvQY+rc8tZOI
w33jj2QuUVhM9zLkLISPnYi15dONuH9cf9w3pc1148Sck38CME+gpu/z2Reo4mAF
JeE9FRGXqVV9C3Pwfhoqmct6rlYYYW/klmEDwtnmrtAXqG4vVSEnIselPwcldBQ1
r3TwNF9VnCwtk3WnHQwanaZIKpFGSTdsHyUQkSaFsRWvqI+AsxgufRC9dmZwL1ck
pijA8qyTd/QbV6HxxV4N
=hDnl
-----END PGP SIGNATURE-----

--EnWmfqINw3pxcJoC2x2Q7tO0TLBvKK2WT--
