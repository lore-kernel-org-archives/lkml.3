Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbbAMJs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:48:56 -0500
Received: from sauhun.de ([89.238.76.85]:34788 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbbAMJsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:48:54 -0500
Date: Tue, 13 Jan 2015 10:48:33 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>, jdelvare@suse.de,
        arnd@arndb.de, maxime.ripard@free-electrons.com, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, andrew@lunn.ch, sjg@chromium.org,
        markus.mayer@linaro.org, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V3 1/2] i2c-designware: Add i2c bus locking support
Message-ID: <20150113094833.GB1059@katana>
References: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
 <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
 <1417478973-25522-2-git-send-email-david.e.box@linux.intel.com>
 <5480144F.2040506@linux.intel.com>
 <20141204184210.GA1530@pathfinder>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <20141204184210.GA1530@pathfinder>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave,

> Timely reply. Around i2c_dw_init(), yes. I just discovered this as the source
> of a recent hang that's occuring in the loop in __i2c_dw_enable().
> The hange occurs very infrequently and only, so far, when not built in. A
> block around i2c_dw_disable_int() would make sense as well as a precaution.

Any news on this or on a V4 of this series?

Thanks,

   Wolfram


--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtOnxAAoJEBQN5MwUoCm2FvEQAJdwWfyiLhh6NOlOoFcdIjZ+
/ihzfEPjwYAiczC5et9PsSWxc41KglB0qHjNxX5IAsyu/nMw/DHZnmpm9rKrlZsI
jJtBOSO/sdxBuybKfVp2pyTGBO2WAZsSPi5iswporHzF8mDRKJClXu+F1lin1HAt
ISWHu40eEwC4Dh435S21JxY298GeA61AlvjY5+CRXUZJPR6Blea8Dwh4EgR0wUkE
X78Bo3MZhGwP72rfCKYjGl1CP2UBph9ec/gQeadbXm6I6iJRlZOKDMZqKLCt0Lsy
c/OJu9pxWtRRru4wCXJqoUhWlEQIr4Ivd7tjW9LT/zCEe/vYZjLLob6dFAdRtIDP
aVeYgg3MY+ZzaxOOa089yHdrRbmobyf8RrnlkRTA0/I4OkH6H0P3r02S9RN88sWG
zueMo8KipK18dIdGrndsJeiNU0GRSCEHv264KrcwdXe21fAcZehvhKSzKycMkChb
c6qs3vtoDOLcp0j7eWGDhRA0ruYV6Xr1LjhvwIl6m+3FxuuBThCxa6p2cacQ371e
nLCL0THpgdVjojOnyQFFBqAkjTr+8Y+rwmqwGWrFkManwckt0WahojnRA6OL1iO3
8gGdr/S0Gb7bv3WjLuTuQAA93mx6WMapsBEcZW1MsB/a9S4nLDK+Y0NSOdSttitg
h9U/j1kEq0bYKNPoy7Z+
=ForJ
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
