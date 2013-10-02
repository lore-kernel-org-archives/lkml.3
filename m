Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3JBJDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:03:17 -0400
Received: from sauhun.de ([89.238.76.85]:37747 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab3JBJDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:03:12 -0400
Date: Wed, 2 Oct 2013 11:02:57 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Subject: Re: [PATCH 1/4] i2c: busses: i2c-st: Add ST I2C controller
Message-ID: <20131002090257.GA3059@katana>
References: <1380623952-4252-1-git-send-email-maxime.coquelin@st.com>
 <1380623952-4252-2-git-send-email-maxime.coquelin@st.com>
 <524B346C.8070607@wwwdotorg.org>
 <524BDB00.3010508@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <524BDB00.3010508@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >> +Optional properties :
> >> +- i2c-min-scl-pulse-width-us : The minimum valid SCL pulse width that=
 is allowed
> >> +  through the deglitch circuit. In units of us.
> >> +- i2c-min-sda-pulse-width-us : The minimum valid SDA pulse width that=
 is allowed
> >> +  through the deglitch circuit. In units of us.
> > Are those properties specific to this binding, or intended to be
> > generic? If specific to this binding, a vendor prefix should be present
> > in the property name. If not, you probably want to document the
> > properties in some common file.
> Ok.
> In last revision, I put this properties as specific to this binding.
> Wolfram proposed to make this generic, but it looks like this IP is the=
=20
> only one
> needing such properties.
>=20
> Wolfram, what would you advise?

It might be the only SoC now, but I could imagine that other will have
something similar in the future. I am not perfectly sure, though. So, I
asked for opinions from DT experts when I suggested those bindings. We
could start with vendor specific bindings and generalize them later if
similar ones appear. Yet my experience is that old drivers rarely get
converted to the new bindings.

> If you still prefer to make this properties generics, in which file shoul=
d I
> document it? I don't see any common i2c binding document for now.

Yeah, it is missing sadly. That's on my todo-list, like many other
things...

Regards,

   Wolfram

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSS+FBAAoJEBQN5MwUoCm2/scP/1bT7YqvhOtcIKhtOTu1pgXT
NFSg8K2wWjukKx3QdrRsg5TvjHqjLJnOoS/H9nOWods1reZp4tVqH1EvemCh5koF
+1F/PCCGm6vI9eiqBd0c2RTN4xPgZAyaXNnPVneDn91SCQY5ZizqFYHDN+PfmLtg
XR5/g6FjxnPv05ifxKpprR9LCHFUd3r76GVGSp2fm+LiPxv135IaO2i5aUegu1Ht
Bkq3UatMoteCD4C1kkW1V+f1RQ94r5JzKWfMRuGKMRATOpnxs4+Ipdt7nRqTbxVL
ytHRxZxz/hE8Ia1CAhgsGynz8SmQxfHTZXhVEYeuFHbIQs+dlauMFC1XiE718jux
5+VTDOdrvbicC8gzn8erYf/348vSPFN3tNyZep5CbRBZrxi4DmwiRUr6MjpXyX8D
293XfEax0zw2E9w8jDKGDoCBVtaXTqINFpDwOP10YuF0DCK+2B6QNJrboD4zRo3R
0jfEvJrtfQPDwgu+RSH0jJxlRmWMC9y1EkytoWHu5TzlMm4wQe8zp9gzam8zT86K
mAaeXx5F1OO1RwKdW16v5NbIaziE9hlgwCMwRAV0iQW3apTk/mwtddP2tTzyHtL/
Nc6mIHTN3tv8M6S39TUMGVBAwAJrDYIRnv7qjfUwEspdcMy2VuwAoofsc3w8dA6+
aZcGCNVQSAx8fzQU4/G8
=LuFj
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
