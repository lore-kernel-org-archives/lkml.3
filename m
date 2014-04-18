Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaDRPHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:07:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37934 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaDRPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:07:35 -0400
Date: Fri, 18 Apr 2014 16:06:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Michael Spang <spang@chromium.org>, Sean Paul <seanpaul@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140418150651.GW12304@sirena.org.uk>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
 <1397689950-1568-5-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1nR+rbHAiJEL631A"
Content-Disposition: inline
In-Reply-To: <1397689950-1568-5-git-send-email-dianders@chromium.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/5] regulator: tps65090: Allow setting the
 overcurrent wait time
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1nR+rbHAiJEL631A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 04:12:28PM -0700, Doug Anderson wrote:
> The tps65090 regulator allows you to specify how long you want it to
> wait before detecting an overcurrent condition.  Allow specifying that
> through the device tree (or through platform data).

Applied, thanks.

> +- ti,overcurrent-wait: This is applicable to FET registers, which have a
> +  poorly defined "overcurrent wait" field.  If this property is present it
> +  should be between 0 - 3.  If this property isn't present we won't touch the
> +  "overcurrent wait" field and we'll leave it to the BIOS/EC to deal with.

What I was driving at by asking if this was the raw register value was
that the binding should make this clearer ideally.

--1nR+rbHAiJEL631A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUT+IAAoJELSic+t+oim9j8UP/3DomAkluVtsjECQ0zQhMleu
wf2m9lA1wm47hvQSah5FWauysoSfKryrbODUAw1F+Uy19UIZEU/X1HatllWWQT7y
RQiDXYIlU/W9TK6d6B574Ct64PvGnfLXMg2LUV0JFKUXOOm6o+N6hVQfjlY2O7Qp
bqsFcK3TP7+slXMCR+f2eoBoUiGj4L8BSq+fU6VWahpLsGWQlHlASlUj/HcMKajw
a1IJtgrb/ddZb56qjr8ijxZ7aMIapQpgqrmkfuugtrOgNTmwwR7B3H841uwFm8MH
OolspJDPEJm9NSK10597drGLKriOJbds+alS+gWyY1moZfgE3U/Z+OLze2m6QcHi
JP+Pw6vGTLpGY8zILfxDJLa2aiFRz+0og9ah3/YRGrCipKT8RcoyU/ZqRESDmbXk
zMSyOs95mV6S09csHcAocOso4p9rkr+wJ9WjsrtczarwdiV9MMzb9nuZTwdCwfD7
vC478LKjPQ15Sg5zzbLFiH6rY5UKnQxPuOUuE+fWSLYzR+/pk4Geri7qwVUYNFHI
aWZb0hlCnSUewy39s0/qW3voDTDRsKCQ+PPlhVNREU+Amc0+AmKoTamHY+NXj5c4
2ljPQ65EXsCqd1wZCA/KYq/zD/sd3LARVF/HBX0DW0SylzBV0QlKRzntweHI3FRE
uJGoXESN0wZGfSkdYko4
=jtIa
-----END PGP SIGNATURE-----

--1nR+rbHAiJEL631A--
