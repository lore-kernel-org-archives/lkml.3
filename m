Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbbAVUly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:41:54 -0500
Received: from sauhun.de ([89.238.76.85]:42459 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbbAVUlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:41:52 -0500
Date: Thu, 22 Jan 2015 21:41:47 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Korsgaard <peter@korsgaard.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-ocores: add common clock support
Message-ID: <20150122204147.GA16770@katana>
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
 <20150122144522.GF3413@katana>
 <CAMo8Bf+XJY_bY+OB2i_SZQmAavwERG39BR8FVj202V-E3UidPg@mail.gmail.com>
 <20150122150717.GJ3413@katana>
 <87wq4e7jqy.fsf@dell.be.48ers.dk>
 <20150122185711.GA14880@katana>
 <CAMo8BfJCPQWa-AGODDO5o2XZU3d-BbaxjSSG9SOoMzoXpYtr-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <CAMo8BfJCPQWa-AGODDO5o2XZU3d-BbaxjSSG9SOoMzoXpYtr-A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 11:36:25PM +0300, Max Filippov wrote:
> On Thu, Jan 22, 2015 at 9:57 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > 2?) a new binding is present to specify the IP clock speed:
> >         - is this needed? is somebody using the driver without CCF?
> >         - if so, the new binding is parsed and evaluated
> >         - I couldn't find an existing binding to specify a clock speed.
> >           Please have a look, too. Otherwise we need to introduce sth
> >           like "opencores,ip-clock-khz" probably.
> >         - "clock-frequency" is describing the bus speed as usual
>=20
> ePAPR document says that clock-frequency 'specifies the frequency
> of a clock in Hz', not identifying which clock. Outside i2c drivers
> subtree it is commonly used to specify input clock frequency of IP
> blocks, even for bus controllers, e.g. SPI.

I know; it was established in I2C this way before I took over.
I don't think it is a good idea to change that.


--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwWCKAAoJEBQN5MwUoCm2/agQAIyKeAeSIClpWpxMXtPJ10ky
pF6WLHz1Knpvq/nYPDN5DvQLycwll4J5qDaXYtn+vMJJnw/E7wHIB6uI7y0NdEh+
scyMKudbHWXBCm3Gzac5te7OMuJARDgOROyLzB+nLmq/hZmkRcSD+70LLNx/VZb7
my0Cygv+a4k1F6UGqkhDJWc23BHCwo3vPvhp3QgEiRvKIEYBF5U1V1pKJbVRLdl3
fMx6LAkTP/oSzQB41P8aGQmWyLtUu98bTITavNRHsKqr9nowQ3tzlzSjQSWds9dt
xEtXi4IEC7gVOQsveYlfVY2ugwWnb/sWVoMBiwyzWJHmuycOLcPs/2us41cwUjpx
jWy/bKtSetH20EAM6orJw7bIXQ4FItlefuDlbX1xh6OTRfXGzYRPOyCmPQVJlTYK
MZ3nru5SvM0ex/TwW88IK3gZ8bQA6vksANnydY28fJiTvlN//OkcSZrH3qFz3qKw
K9EwKct88W3+BCu/4VUAyuq1CjdBdm1V1eO1q64okS+aJq/fvzM5ueys8jPSYueD
KyyPAdnYknDuhU8lI01DbIv1Ik6P1/+1K5YI1sqrugElmq2FapgRogufds7UKq00
AkKihxiHbq9BYfHnch2bRuc6I7eopPuL9c7bDfzjhrK0uA+IEJjmeulTRfdf2r4/
rlnWP5hp3OlLl+2x97bz
=Cqjn
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
