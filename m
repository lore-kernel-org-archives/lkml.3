Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946309Ab3BHL0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:26:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58334 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946244Ab3BHL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:26:40 -0500
Date: Fri, 8 Feb 2013 11:26:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: core: Optimize _regulator_do_set_voltage
 if voltage does not change
Message-ID: <20130208112638.GL8879@opensource.wolfsonmicro.com>
References: <1360120188.8965.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRwESHC7KXlqFpSs"
Content-Disposition: inline
In-Reply-To: <1360120188.8965.8.camel@phoenix>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XRwESHC7KXlqFpSs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 06, 2013 at 11:09:48AM +0800, Axel Lin wrote:
> Optimize _regulator_do_set_voltage() for the case selector is equal to
> old_selector. Since the voltage does not change, we don't need to call
> set_voltage_sel() and set_voltage_time_sel() in this case.

Applied, thanks.

--XRwESHC7KXlqFpSs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFODoAAoJELSic+t+oim9xPIP/0JGVT7VrJwFh7mhLqi4Nb6D
FxBIB7upGebrD0p3qn/PlNjwGGzh1wp93QdYq0Y+385jjwICkoVyNqjyrg6gntHq
BdQyn97U/RiLhgaFqsbVneRoqnThr5KP3+eMsydJtDkY6I3XNcWURHh//tfmngwB
mmhE74baqXjRbiY6NASGBFlEpkCNaGxUfuAC+oXLdmOHOlro2X9901lY9jO0eut6
QUg9M22S9IyfmXV0twprBna905FdklkS+KzR2FYAluvTNvtd4eQJDgsjz38BBsUq
pZXAaaewYAvGq5dsMOuipWZFugG0lgt3OwtIbr//BjUv+HjW3X4mvW0v1bkOABkM
xvUbP8pqUHprOgAqsacQr3WdLDdB3EmOD7W7lYzRa1IciUDqnozLPBwzequkY3uS
GtNeGNMN/NP2KNXN4hYqwWSVIMgYUGbiQEIwgweBjeIpvgjMO6FJG2oSgj4HKUi+
ub37BY7CZ+TnsY3XqV6uRqygbeQvTxbneWQaDoo8UF9+3jn9KQD3PPcr6l+yiyKP
eTBT2upZZQ53/rs67qbHDS8OBhMxegrnTlCn1tXGmTklu/PXT9NbqPwkJk2dpVK5
Rc7BbP3mdhOy8FQGnUeo7t0xfAXL3PxhueogfNPKGfWDWU8mQMFh+zbCuSk7fq3n
OH89I+fuM1TMokGb6XSQ
=Apkn
-----END PGP SIGNATURE-----

--XRwESHC7KXlqFpSs--
