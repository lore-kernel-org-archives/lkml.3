Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab3BLMEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:04:36 -0500
Received: from multi.imgtec.com ([194.200.65.239]:45581 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941Ab3BLMEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:04:33 -0500
Message-ID: <511A2FC2.7010909@imgtec.com>
Date: Tue, 12 Feb 2013 12:04:18 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        <linux-sh@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] Centralise CONFIG_ARCH_NO_VIRT_TO_BUS
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net> <CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com> <20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au> <5118DCA8.1030905@imgtec.com> <20130212154010.3f8b88da4756c7cf04e28a04@canb.auug.org.au> <20130212224729.5e60d0303bda923bebcc1185@canb.auug.org.au>
In-Reply-To: <20130212224729.5e60d0303bda923bebcc1185@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigCD18698F87994248FE52F0D9"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_12_12_04_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigCD18698F87994248FE52F0D9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/02/13 11:47, Stephen Rothwell wrote:
> Change it to CONFIG_HAVE_VIRT_TO_BUS and set it in all architecures

nit: typo in "architecures"

> that already provide virt_to_bus().
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Cheers
James


--------------enigCD18698F87994248FE52F0D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRGi/CAAoJEKHZs+irPybfbLoQAJcwSYD3NK1dOp1OC8OUY4tF
SA0WEPGCHUY0ewKfTfJAxzxeiKBL0/v0EigmMktkMmg/BauiT/75q4/EG8SxjnD7
Tf/pZ0IlTU9xM5dYeqSNEeimxZv8gXp5DEJ56+UV8pSZ0PhtNowKCTnePA71DtO6
mFNYP9GcjSxNYHfYTzHxLEhp0xfSTVWrOpW0ak+y97XMQOS3Yxff8wSizq7LhBcG
H+t5J8paEWs73BJsZKzVtkdDyp4Tv5shjHhl4TeGv7doxcYykX5yIlWxgZLFRRI+
3o1JACl75gmFDxGi/2cYK+mkp24SupVYNGw/teRrsKGOoGO6k30XLG3COlYQCSOb
mslGyP1DFryONBNcRJ3gT8dkyv9zsoL0vwMj6TN1e36MnAAlKoAnziJZ/kpscR4F
IOuEPBtOjothoEgA9e+X/BdkGBh3kLztZvFE72wWYIX/r9+ynrWi85SZDcxMG/o+
f/uvRaOIRI5E8nPyapat75veiw7GWNl5ZxvCRzHl8e1xEWUb/PWlJma+fd7sAZLn
fFlCPQ53QG//t2t1Y6OjiNbzOJsj+1yMI/EHULbeSVALUyvYPzaH+yfCvHwIBNTx
vbb0JQKEB+syLW5QNYIBOpBCkyMYrEW+TUHj3MUIXJ2JZgB6e9P+HUKwQXb7PW4F
6gotw7qwQEz9aNx36fBk
=69Xu
-----END PGP SIGNATURE-----

--------------enigCD18698F87994248FE52F0D9--

