Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaAaQDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:03:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33382 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaAaQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:03:52 -0500
Date: Fri, 31 Jan 2014 16:03:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Kevin Hilman <khilman@linaro.org>, Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Message-ID: <20140131160328.GI22609@sirena.org.uk>
References: <1390993850-9054-1-git-send-email-maxime.ripard@free-electrons.com>
 <1390993850-9054-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140129122520.GY11841@sirena.org.uk>
 <20140129133227.GQ3867@lukather>
 <CAGa+x854huSmiWmEv2EgOPUgZKcp3iitNaBvKXt8DiEj8msSVg@mail.gmail.com>
 <20140131081147.GC2950@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RelyVQTGfPeWBXwZ"
Content-Disposition: inline
In-Reply-To: <20140131081147.GC2950@lukather>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RelyVQTGfPeWBXwZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 31, 2014 at 09:11:47AM +0100, Maxime Ripard wrote:

> Wouldn't it be better if it was suspended by default, and just waken
> up whenever the framework needs it?

The aim should be to come out of probe in that state if runtime PM is
enabled but don't do it with these hacks, do it by idling the device
at the end of probe for example.  Apart from anything else this code
just looks ugly.

--RelyVQTGfPeWBXwZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS68lNAAoJELSic+t+oim9iSAP/js3AxmDpVbHs3m7d+fv68Fw
CsZOZdFbQgi0NB/XqQPCK/EJT/yGQs9nXyTzyPAGRi5Dn9Nu4Xc5JLFu24m15eg2
RNWATXq6sftb7Mk3Khp5yrdrF9XfjUUAuO5Jki/Gc5k6QrJvRm468bU1BjtoDx3C
37KyXjl1XxqYGeGQmnj4om09FYdqCbzAok1mxsa9kXQELs4LVq2096YcVxSzesJu
OPRRU6oBAap9kqXv7+V58V0/F0FHZmz5OytE7FsGHghc88dbQ0UVUtx+NU2egy2k
T3lcYbE51hGL41mryK3hv7D4xygWbxTUVnmBD4RcItTeaLekWvkAREe2Pug2rVx5
egyZBbU5xniXBE+RkLYmENDm4uAfeT1UjJOaY+azfSVKp63dtMZDLTWyN6vl9NJ+
pJUOsvspdCMBlmPlSNZ0x56sgDehK9o1rVRVvaWNFaUFGmzx5m3cfYTDdnBCsvWx
3qM3KODnFAok+s+j0HyNUMeyKiRdx9U1otHdmSZ1ilynxvRrTFRs+eNnreSscQDS
euroErykTPM7ZGy2DKg81xyjLqK86DqjhlHnQjk+1Jgtfv3YPTojNUth3w5JAjA1
8652xz16QY+pajsDABw2WjklnxR4qBH4kpl7BsPGeRFcy71aJeDTIcKPqtZf+TrR
FZ1HLs8M7Lo/KhS3zpmz
=N6v6
-----END PGP SIGNATURE-----

--RelyVQTGfPeWBXwZ--
