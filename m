Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaCARMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 12:12:36 -0500
Received: from ring0.de ([5.45.105.125]:45887 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbaCARMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 12:12:33 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 1 Mar 2014 18:12:27 +0100
From: Sebastian Reichel <sre@debian.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Marek Belisko <marek@goldelico.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [RFCv4 0/7] Convert twl4030-madc to IIO API and add DT support
Message-ID: <20140301171226.GA3337@earth.universe>
References: <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393444990-28140-1-git-send-email-sre@debian.org>
 <5311CA14.6080009@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <5311CA14.6080009@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jonathan,

On Sat, Mar 01, 2014 at 11:52:52AM +0000, Jonathan Cameron wrote:
> Obviously there are a few outstanding bits and pieces to be
> addressed. To get this lined up for a merge...

I will send out a new patchset in a few minutes.

> Lee, do you want to take this through mfd or shall I take it through
> IIO?  I don't mind either way.  It stands pretty separate in IIO so
> shouldn't cause any merge issues beyond minor fuzz.

I think it makes sense to queue it via IIO once I add the ABI
documentation for the IIO *_mean_raw sysfs entries. Also I
think it makes sense to add iio_read_channel_average_raw()
in this patchset, since its needed to convert users of the
old madc API to the IIO API.

-- Sebastian

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTEhT6AAoJENju1/PIO/qa1qcP/3LkizLrH6QnSM9aznFkQ6qW
KZ1eqYXw8umtXxVhljApAUq8QLFCT07yePW7Yhs23eEXBBb/3m/wpDMC54vIaSdS
rJLgNM4Tm0zmB7nVOMFoTto9dpTQZnyb/UP8zzHX2TkMu922j3rt4u/gAuKZ2eu8
4Bcrrx/oEg3DhRpHEwxvNVt7+jcDPHacNreXa0fSv5rMVXz7ptyNvCh4XJVP1b6l
DvniowmwmTTpCA16nnN4xAwiuaKK3XNRyg2ClhR8bWN/iT/C3NFGFyd7hS/iFmJ+
7kUweGnixuBGdfiKCMlh9LZNJcgA+x97trMbA9cPh2p3DMiuSPLWHYP49Q1jyOlR
/FF50/kuOF9i/rLR8cbI5j/EM9KqF4lPsvnEVTsdxVR3ryeYJBpA8dURHdHWWfuZ
ZGI9uSnH4Rul2/7tLKxdVEFmEU0XBKIZTi8cWybpN3nJA42Nvd5D1Ig5U7vy/VEf
9Kg9RW5jzNFiyTrnGytvh+DSforbvCxYsTo8BuBvCx+LAJn1OFcMjbZpcO6RZa0i
yTHeAmF++7Z4kIu/SskNGH/yJ9xzjAYOoBL5H13J+6W6I41dYiNTtt0bUNVi7HFW
8XpYaGd1xYEQE2jWmmCMLHBqnxCL95DU9CVRfHvFtQnUFPeBU6J7It1bByDIHrMb
Ljuxi2QOIrh8A8gjq8HQ
=E5Rg
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
