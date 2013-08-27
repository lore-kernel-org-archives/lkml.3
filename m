Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3H0KKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:10:03 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44374 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab3H0KKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:10:01 -0400
Message-ID: <521C7AF0.1020903@imgtec.com>
Date: Tue, 27 Aug 2013 11:09:52 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mike Turquette <mturquette@linaro.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: manual merge of the clk tree with Linus' tree
References: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au>
In-Reply-To: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="X09MRfRa7snNnIFpOU1B33IOENhS5vHj3"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_08_27_11_10_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X09MRfRa7snNnIFpOU1B33IOENhS5vHj3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27/08/13 10:03, Stephen Rothwell wrote:
> Hi Mike,
>=20
> Today's linux-next merge of the clk tree got a conflict in
> drivers/clk/zynq/clkc.c between commits 252957cc3a2d ("clk/zynq/clkc: A=
dd
> dedicated spinlock for the SWDT") and 765b7d4c4cb3
> ("clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes") from
> Linus' tree and commit 819c1de344c5 ("clk: add CLK_SET_RATE_NO_REPARENT=

> flag") from the clk tree.
>=20
> I fixed it up (see below and in a couple of places I chose
> CLK_SET_RATE_NO_REPARENT over CLK_SET_RATE_PARENT, which may, of course=
,
> be wrong) and can carry the fix as necessary (no action is required).

The case you mentioned looks correct to me.

I can't see todays -next yet, but if by "choose CLK_SET_RATE_NO_REPARENT
over CLK_SET_RATE_PARENT" you mean one branch adds CLK_SET_RATE_PARENT,
clk-next adds CLK_SET_RATE_NO_REPARENT, and the resolution ends up with
only CLK_SET_RATE_NOREPARENT then that sounds wrong, as the two flags
are orthogonal.

Thanks
James


--X09MRfRa7snNnIFpOU1B33IOENhS5vHj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSHHr2AAoJEKHZs+irPybfGHgP/j6sDUy2LuGW1itm+H+lXGHf
DTmo6IBsWN1F2nn0LOpY1SnA/qSrmGoWTz9OSGuLq2UCUxDGJ/QYPMjl9E6TWqjI
h7GaByf832kqqKbHvU+MQNadNP7SEhPHopgTBcedvTwLUd1myxkUN+Y1tEs/x9ne
H9vj5faQqZ1xQ6D+6jfUfN3R7iTacXQiaJ5DaQF8UMdcDd8AdQmSSFk6R1XFfydZ
ULGJfoLORCswPzhjQqyvUW3h4M7etGrDZKiQDNHt8K3levC48KPxnBkt6pd2JzgT
Roq8TuBRadI9QQEYdNBjQ+2nYdirl8qUAcVt/wH0NUKp58rgp7R1jiaiCIB9vVEd
10KICgTGkF2nFtyi6iPHkn92Xeehj85A/Vb5C9NV0wNpVfvyWR/59jvuZDLWcCHT
SWNQ+am6OeHZx4q31eToJRYlnRICNImY4TpLfURC/ZrG/if4JNxkr9ttE6RFVhGq
mQZSVw0CzUgZd9X+nl1WagCMi3r04gX4Q+LnfVBAEiYWn0768Pj5j9oaNkD3/kWm
JIVdKSg+0mD2ewAIzuzFD2RhKLT7csZL+Ae/nrMb6wSjjCDcjPgmRRvlvRq+4DpV
0QJ5TaPK4sCxluGDr54ZJ63fF1CkhXHs9iVcHrM8QAt4hTWKMpB/9NStk8PdRUH/
CHyFfXsR31T8gKY9BYSX
=EOm4
-----END PGP SIGNATURE-----

--X09MRfRa7snNnIFpOU1B33IOENhS5vHj3--

