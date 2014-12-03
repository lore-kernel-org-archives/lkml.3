Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaLCMTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:19:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39386 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaLCMTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:19:22 -0500
Message-ID: <547EFF91.7040405@ti.com>
Date: Wed, 3 Dec 2014 14:18:25 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <plagnioj@jcrosoft.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>, <hns@goldelico.com>
Subject: Re: [PATCH v3 2/3] Documentation: DT: Add documentation for ti,opa362
 bindings
References: <1417352867-7436-1-git-send-email-marek@goldelico.com> <1417352867-7436-3-git-send-email-marek@goldelico.com>
In-Reply-To: <1417352867-7436-3-git-send-email-marek@goldelico.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="FGD71uUJv2Mt07HihEmfgkv9rcNFNp7eh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FGD71uUJv2Mt07HihEmfgkv9rcNFNp7eh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 30/11/14 15:07, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  .../devicetree/bindings/video/ti,opa362.txt        | 38 ++++++++++++++=
++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/ti,opa362.t=
xt
>=20
> diff --git a/Documentation/devicetree/bindings/video/ti,opa362.txt b/Do=
cumentation/devicetree/bindings/video/ti,opa362.txt
> new file mode 100644
> index 0000000..4747ef9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/ti,opa362.txt
> @@ -0,0 +1,38 @@
> +OPA362 analog video amplifier
> +
> +Required properties:
> +- compatible: "ti,opa362"
> +- gpio: enable/disable output gpio

Either this or the example is wrong. If I'm not mistaken 'gpios' is the
correct form.

 Tomi



--FGD71uUJv2Mt07HihEmfgkv9rcNFNp7eh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfv+RAAoJEPo9qoy8lh71PyoP/jH0TKf2mTKRM0mk3KY08LJb
yfnzOFb0GybghvFvdf9c415HFa0zReQkw1d/zSIpLU9ZC3jWcH5vUR+oxsSpBiZM
xhvU3hAqUm4P4NjIekWpOI7vhnk3NdQLVGYrIMFzSTHaLigi7xzKTnbEYlVsfQaU
0AwRsU7/hkx8aKFUSYxsFvo28CCYROjmwodnnq4B53GnsErdIJsKtqjlwY0i706p
6S7CHUNzj+mQah7gJAFcBgQ/rmnRNXc+NZ3hmRgpeJVDP3XgqFfadjTvveYB1saz
TchQjXTwwE6/bKIxj1eQ0U+Y9UJ5qikyTMfe2OaTNr7eHH73CKLpQbmid41u7cXW
/Mjv9Zs5PvOI4B/bsOZR5AuXfKBvMTzA8Pqp1JMx3oybAFG605AXxuTTONDk7XH3
QdoXo8IEdaRejqsr5CATQLjIdzH2yGrdg7iZjWvmKSPblj8pZ4TGapMqpr0kOgBg
oIwR2Z4mHN6BQLfbmfBMCWvCZlv3zJpv1xP7wuRsp4fnnTGs5aIcvHq73MKxtvk6
0oYmSSnyDIljJu8taPeYVoCjt9e4yM0doetiRFGRzj0/5rPCW2/CcHkC/l9alvnx
pcvI403wi9x4V/GWrlKTu04GK2JWt0TjJdgEP15G60tcHKfYJ1ARwj+hWVUyfyjq
E5r+OHo3sNbjjUy7NvMz
=IY7P
-----END PGP SIGNATURE-----

--FGD71uUJv2Mt07HihEmfgkv9rcNFNp7eh--
