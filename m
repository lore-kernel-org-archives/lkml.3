Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaBZVzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:55:00 -0500
Received: from ring0.de ([5.45.105.125]:54100 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaBZVy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:54:58 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 26 Feb 2014 22:54:52 +0100
From: Sebastian Reichel <sre@debian.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
Message-ID: <20140226215452.GA11468@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
 <1393375569-21751-2-git-send-email-sre@debian.org>
 <CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Feb 26, 2014 at 10:43:40PM +0100, Belisko Marek wrote:
> [...]
> > +       int val, err;
> > +       err = iio_read_channel_average_raw(channel, &val);
> Where this function comes from? I cannot find it in current linux-next
> (only iio_read_channel_raw()). Am I missing some patches? Thx.

Ah right. I planned to send a patch adding this function together
with the rx51-battery patchset, but it seems I forgot to include it.

Sorry for the inconvenience. I will send it out as a separate patch
now.

> BTW when I convert to iio consumer and use DT some of values work
> but some of them just report 0 :( (I don't have latest twl4030-madc
> iio patches).

Can you retry with the twl4030-madc iio patch from today? The
older patchsets, which do not contain the "tested on real hw"
note are slightly broken.

-- Sebastian

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTDmKsAAoJENju1/PIO/qauEUP/AwF+4r9Wk3+oFDongD2CCT+
MPEIn3zhRnksdrOP5X/3pIAjFOFxcmZC3gi4mAkUCZ6G5asEDXwS4LwtdSgZTvuF
W/zpOyFYPY7W0zVqU0jt2xCnpKzSbYfwGY7vSM4SE/2NHl0KYcPC56mUNuHX6r/K
+7+4usAC7Nt5lFjLfwjkZfU5GsPBN69cOEg63M1eR8aC7pBIKxa0Qk1ww7lLz81m
rPjWBOK8Adk60BOMZVBYoUD1kb0WT2Ow+CPzeJuxWGXdltrurrwoAU9R8Y47ukoH
JrNv1hpSitBD5bldKygbwwsZpo+QyEX0LwyR8f2s3Zf6XJP1GYc/gfJAYiebm0UH
K8YR6tH89IMBf5btTXuZvZdCQbcMJwSSUbZ0HZS0tzn345mtbwQsrztk1yl3b7Pu
pVipWYXk6CzM9oCyYJeqtDIuJ6J5xcG6Dfmz6rUcL4PttnOeXwwt3IJXEtel+Y69
rcPiqINWx2RNBfyKfbLzb+hfd/O8QCepA6goZ0FJ2pyXGVbH6+7qyr4FYXaIojU4
kJOdJziTa9HZsblptH6PIp0Ql+qaEdpctl/VLetkQnlRlL8DXdDojZicd0SD9wW9
mS1PkGR1iGd/uCoMpV2vKE91rQBl8L0EVWx5ci7ih8ikOV3E7LCWLOBzdik7EO0Y
zqg+W6U86wqTQZPp+3MK
=HVjH
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
