Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3ISSfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:35:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39125 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:35:38 -0400
Date: Thu, 19 Sep 2013 19:35:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <20130919183506.GJ21013@sirena.org.uk>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-6-git-send-email-linux@roeck-us.net>
 <20130912164100.GF22013@e106331-lin.cambridge.arm.com>
 <20130912165304.GA12202@roeck-us.net>
 <20130916142147.GF30650@e106331-lin.cambridge.arm.com>
 <20130916151953.GA5801@roeck-us.net>
 <20130918153828.GB17453@e106331-lin.cambridge.arm.com>
 <20130919164245.GG21013@sirena.org.uk>
 <20130919182850.GA22775@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PPcTO7KkkZ/DEnPS"
Content-Disposition: inline
In-Reply-To: <20130919182850.GA22775@roeck-us.net>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 5/6] extcon-gpio: Describe devicetree bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PPcTO7KkkZ/DEnPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2013 at 11:28:50AM -0700, Guenter Roeck wrote:
> On Thu, Sep 19, 2013 at 05:42:45PM +0100, Mark Brown wrote:

> > Many of the things described only have passive components attached, or
> > things that otherwise don't need drivers - things like power inputs or
> > headphone connectors, they're mainly providing information to allow
> > userspace to behave differently (eg, display a charging indicator in the
> > UI).  It's not 100% true but by and by large if detection is being done
> > using a GPIO it's probably something like that.

> Correct. However, gpio based 'detect' pins typically need debounce support
> which is not directly available through the gpio userspace API. I tried to add
> that earlier, but was told to use extcon instead as it provides the necessary
> infrastructure. Now it almost looks like I can not use it either because the
> required devicetree bindings may be considered unacceptable.

Yes, I'm trying to explain to Mark why there are drivers just purely for
the connector without any software for the connected device.

--PPcTO7KkkZ/DEnPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSO0PXAAoJELSic+t+oim9oUMP/26unBLbw5V+rqTsD1Qov8f/
zWs1/WBqOSIRClNCPRfIKSbT8kD0GqHgasB8aJvND8JkHRSLJAq1nvdGL8IS6V1/
UCtkAjII4auLwsh8o3gwrMsuNM7CuAaLJuEXg05TB6nU1Qjx+qpuMUTfbJZG411u
JNoxYr9IA7ROIs1wPDcMyRT54RQEV90GQ/yOWJ0aamfE9bTY+FzPqg46PBEk0jn5
l2xbVv/PpTKmxGQZYEZVYAJ5snJzf9Fjr8lLstzsCStRFlIazuEESl7EDTNhxvdR
SES58htyugQkavU73mhbMhOJfKZC7HlSYJUdSEc+kZXomT9rBsVzFZBkg/tcuM++
IBjJMhHLseWqkhgsE+4ExtfNTW+TexRbvn4sX0t66EiRN/akNW5spKkWFsvYiyc9
IU1PIo+v/Io0aOTv2Jo9pjUrZeIH0ibufD24u9qm7fU/dgReXVw/X3FXTrJpupt6
Z702x427pWvFwnGy8DsVoRRDc+XG/0IAoGDRvkmjQ/uNLrDfjRgKf+l7AkR4kPig
22A5/ofjSDoFsz8P/i7Gcow28rcjnybhGClL5T8r453vH1qvTFYCekltpwerrgFu
Xpat+GOWoC5aXEERGdHf6DzVhry5jp/takq0ligglujKH6nHEA5nnpSKNxRTxpNy
Q/epTLiX3xQ17ukbx9YA
=XYpv
-----END PGP SIGNATURE-----

--PPcTO7KkkZ/DEnPS--
