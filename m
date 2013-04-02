Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344Ab3DBIc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:32:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58039 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760085Ab3DBIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:32:24 -0400
Date: Tue, 2 Apr 2013 11:32:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <sarah.a.sharp@linux.intel.com>,
        <rob.herring@calxeda.com>, <kgene.kim@samsung.com>, <kishon@ti.com>,
        <dianders@chromium.org>, <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 04/11] usb: dwc3: Add runtime power management
 callbacks
Message-ID: <20130402083204.GH30286@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-5-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhtSGe8h3+lMyY1M"
Content-Disposition: inline
In-Reply-To: <1364824448-14732-5-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zhtSGe8h3+lMyY1M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 01, 2013 at 07:24:03PM +0530, Vivek Gautam wrote:
> +#else
> +#define dwc3_runtime_suspend		NULL
> +#define dwc3_runtime_resume		NULL

this #else branch is unnecessary. Look at the definition for
SET_RUNTIME_PM_OPS()

--=20
balbi

--zhtSGe8h3+lMyY1M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWpeEAAoJEIaOsuA1yqREWJoP/39b+e0q4u0GkpqDq+9Ly+8M
eQMe79xrBCSHxH4FpDs56nhGdTJQER1WuSkcAjh0OQzQfMXTy3hSQCO1Z/47ZdIZ
y5bNqRU9tj+Q0dltlgjSDL42XXCEzhvpjM8k7sfCuIxSZmPZr4lmUw+A5e2etuM3
3uLWr78/kLoPCMOHOyOcFgyrPm3jOXuEjI+nktjgRxCqeaV4FOJCzZ3CNB3WV7PP
7Az15LDkL6xB/E9ApwkgP/HJnIeaBdmGxbM6fAXzVPtwiiRilruPAyzW/+TDNGnW
+oPeLsdo3ukLjLH2So6ia1HHdEP9IcBuNySEu5FphtnAmH1wPQtp8VJwsAco/Q/K
wf/CYrzcYWH+qDAyCPtZdp4ftbpztePvSETit61RjeAWnPbzz5xXt2i9OSWym2pn
4dPXmH0z/mEEa17aMamclgTGEJf+7NtQoYsMBAPgY4cYQXUb9WgVJFQ3Vo1Wc0nl
EcT1shMYRTBUYdKXWSKHS+3R3afI3wdVs0E2Tu90cTrwQVqLS02dvTNArEJo402s
wxENHn4ewHskaclfl8ADg4h4TK23JxHJxDnr3/BEnHk9r4XgHnMimR1dM9/mxlD6
4yYCbjxN/Fc3fnX+d33bMMHXDW/zHqCOb+GhNdstZIYb+ZfGW4uqFPNyj8UKuz8K
QxuM+uY/tY/p+yevSnhM
=k2th
-----END PGP SIGNATURE-----

--zhtSGe8h3+lMyY1M--
