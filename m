Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbbASOr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:47:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36358 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbbASOr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:47:56 -0500
Date: Mon, 19 Jan 2015 08:46:42 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>,
        John Youn <johnyoun@synopsys.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH v2 2/5] usb: dwc3: add revision number DWC3_REVISION_300A
Message-ID: <20150119144642.GD20386@saruman>
Reply-To: <balbi@ti.com>
References: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1421654209-6486-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <1421654209-6486-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 19, 2015 at 03:56:46PM +0800, Sneeker Yeh wrote:
> Add the contstant for v3.00a dwc3 IP detection
>=20
> Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
> ---
>  drivers/usb/dwc3/core.h |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index 4bb9aa6..8090249 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -776,6 +776,7 @@ struct dwc3 {
>  #define DWC3_REVISION_260A	0x5533260a
>  #define DWC3_REVISION_270A	0x5533270a
>  #define DWC3_REVISION_280A	0x5533280a
> +#define DWC3_REVISION_300A	0x5533300a

looking at Synopsys Solvnet for this IP, it shows that current version
is 2.90a. There's no 3.00a. Paul, John, is there a 3.00a version of the
DWC USB3 IP ?

--=20
balbi

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvRjSAAoJEIaOsuA1yqREqyIP/3XBnqW9XhXxzuZNM0P+I+cZ
0lXliX5TJ6N31c7IxzxWxLizG7oOKCTm7t9dHJtzIWVYIyXg529kslfnl7SYO+2+
0Nc5uMY3a8EF3Cz5CCwjkhqJIrq8OfNPh1ACBCg60CxY1G956hannwjKIo97RIsG
PLoxPQW7ryPkK09gi6f1ZCfsj3xMNFma5ulFIogVctor40Psy3bRRT0WdlCkLUi0
GApw/+jFcDzTgblHrf5B5USuC0rIbWMpdgjuws5XTxbRsqKiC49wpCkB4/Q9URFl
acinYw9zUsP+FCU0W1dVVQcc8h74nBAOFbqOm/ta6Nbj994euyMKKtgDfXx4gN/F
k/UT42+qxxP4i7AtijN1s0bEGZl5xCqZ60vVrgdcqjJkDQvBZgbNRT3v0PsobNdL
+CtFAn82N9I2x43Cw5JWlHmT7xeiNYrlVh0Lf67atf6Md0KIvEM2F+T3k7VtjPs7
6w0ORgRkZQZFggRXP7X4EBOi5KglOGdsVasTldo5l19AeSP6NLrEgbd5WWXMxzWg
2+3LSirwYcpr0T/Z7Z+Ll8Goh+kUaYRuFZbuwDV3KZ4dVlkPahTTInNxakcAL8Yq
M/pN0GOG06xqhnYGJdIL2/SgqIOozbNXEbU7dgvqKaWOSMe1aEX92EdsOfyaQL0C
tXt8D7GzV5GOSHr982z9
=mmjK
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
