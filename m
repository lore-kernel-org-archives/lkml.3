Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab3JNOPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:15:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58042 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3JNOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:15:44 -0400
Date: Mon, 14 Oct 2013 15:15:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20131014141500.GA2443@sirena.org.uk>
References: <201310111442.r9BEgxmJ029386@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M5PHxtWZRXQUdpfa"
Content-Disposition: inline
In-Reply-To: <201310111442.r9BEgxmJ029386@swsrvapps-02.lan>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] new API regmap_multi_reg_write() definition
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M5PHxtWZRXQUdpfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 11, 2013 at 03:31:11PM +0100, Anthony Olech wrote:
> New API regmap_multi_reg_write() is defined that allows a set of reg,val
> pairs to be written to a I2C client device as one block transfer from the
> point of view of a single I2C master system.

Applied, thanks.  I'll also push out a tag "multi-write" that other
subsystems can pull to start using the new API prior to it hitting
Linus' tree.

As well as implementing the feature for your devices it would be good to
refactor the code so it's implemented inside an internal version of the
function so that things like patch application can be implemented in
terms of this - that way they'll benefit from any work done here.

--M5PHxtWZRXQUdpfa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSW/xhAAoJELSic+t+oim9kmkP/27jI7vhy1JYZC8t5FQkzHll
GP0R5t6O2vxy5/mSPLkdwKdnxhHc6Stj0byKmXYhiQaZrn79gq3TOM9B5Tb86mzq
xDwmcVnZv49VCbtn2GVgaw42awO0qfjNh/xWRl8cJ4vni+pWrHIZ9NVYX6KemjBc
NdK6qpu/ItB8aVzU1rG1q5Ai7LF+h0vqelVudJXuzY+DUL5YfSkt22Mrxx3tbQA/
V0rnYHYGgP/NFEFVw/3e3kA5pIwG0k/8NqEm95RhflS1Ay7QEpEiehAJvCivTqF7
bn30VyfagaVqbxDJ9B0Ckbo+FU3uEWzh1TM4yFzMAysBEaVbjCn/WmwhfPIg9pCy
ChxN/YctNczniByxQdBWCzFjDRsBpvIffXFzJYbmAN6TdjVfEzUQA7bMWEuN2QCB
ozTLw11F0cvONAjeMfNiAWB30SBS3iv9UhBVDfLRXcMWT+YssoSJzajeQYahnRw1
4X67gda5CL+NMVErKOWHBZmWnVRF3U7eJl9WfXGNIxQ+H5EHfRcmm75uZSVWBzor
Xu4v/4VuowF6C/zKGHUqy5WBDEknp4cKaLf2MYc+3l1caKruf1j5TMZ9XOXFmqfW
BpGIHR54SBE3SCRpaCnkZIWI4xpS04V/NJzgoUs+ZezO8djPBv4XmTKGVi8gBHWQ
tCqjqlRZuUCF8/CegmVN
=5c0c
-----END PGP SIGNATURE-----

--M5PHxtWZRXQUdpfa--
