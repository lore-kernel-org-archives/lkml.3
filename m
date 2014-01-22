Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaAVTty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:49:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58320 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaAVTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:49:52 -0500
Date: Wed, 22 Jan 2014 19:49:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20140122194927.GZ17314@sirena.org.uk>
References: <1390406848-20964-1-git-send-email-k.kozlowski@samsung.com>
 <1390406848-20964-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cuTOFZ26ESCmzf04"
Content-Disposition: inline
In-Reply-To: <1390406848-20964-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulator: s5m8767: Document new bindings for
 Buck9 GPIO control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cuTOFZ26ESCmzf04
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2014 at 05:07:28PM +0100, Krzysztof Kozlowski wrote:
> Add documentation for new bindings for controlling (enable/disable) the
> Buck9 Converter by GPIO (BUCK9EN).

Your CC list for this is *very* large...

> +	- s5m8767,pmic-ext-control-enable: regulator can be enabled/disabled
> +		by GPIO (valid only for buck9).
> +	- s5m8767,pmic-ext-control-gpio: GPIO specifier for one GPIO
> +		controlling this regulator (valid only for buck9).
> +		This property is required when 's5m8767,pmic-ext-control-enable' is specified.

In what situation might the GPIO be present but not usable - can't we
just use the presence of the GPIO property?  Also GPIO properties are
supposed to be always "-gpios".

--cuTOFZ26ESCmzf04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4CDEAAoJELSic+t+oim9Pq0P/31Fbn4RJnd39sT3N+pWQI0l
EMBxB8o7fmDQdNym/B/Zs8zIqVFWIFEJexP2071vVE3zjodBJH2msQD8E0OK8W7p
p/Hw8Dhloj8G4QnqiXsvfl/wFpwe0NhcDeaOLDSYX4W7hT5V2HI47D+LAaU7mFo0
EMJ/pWUECbiekt+X3xgXBEh3ysh03I1QRDl299N+NuQHwwRzilqIcYHhpYppU1je
npwa/C6sNNeCVR+Dmgw22g7wjTTqK5+M040j8lDpQW2sSdd2ukgFNG+rN+RMF8Ng
XiDWyCPNsToBYQq5uemR2dDbq4hJS6RkAS+zx5LO1koNQMKewPCOV+Sjhpdvo5cM
fis6Ec1xR55++yiOwACGHrH1GSy/ghMybQIxTFZI/9X6FouwKNXpp6A0TJX38JTT
50jGVvkJdbbaBxoeqYzIcXGVLdmV/PhvXV6k/ws8MvRpKzARMiBU9LhXqB2jd5rt
nJilduKnLxTLZfoyO4rRos2FQNV38tMQ2cznEEc/U180iYt1fpoSRzXAa8XTI9I9
1ASzbEVtZf/LPD94bZRd7II8sa8yH0aGUddC2aceGPlCsvAod1ALWd6CsfR5KmIs
JiqgJv0yfnlcHQDhHO2G6GBTtL+PTj5ZAjnp3GeM69sG+lXFpYRJurBCGSf9nTv1
fw/zDZCYC4NRQslR+sCY
=Hu/4
-----END PGP SIGNATURE-----

--cuTOFZ26ESCmzf04--
