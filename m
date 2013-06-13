Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab3FMPin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:38:43 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50200 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3FMPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:38:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3 0/5] Renesas TPU PWM support
Date: Thu, 13 Jun 2013 17:38:51 +0200
Message-ID: <4097084.Y91d0ZYkWB@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130612101250.GB30841@mithrandir>
References: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20130612101250.GB30841@mithrandir>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7071856.evoBBcrJJv"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart7071856.evoBBcrJJv
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Thierry,

On Wednesday 12 June 2013 12:12:51 Thierry Reding wrote:
> On Tue, Jun 11, 2013 at 03:45:39PM +0200, Laurent Pinchart wrote:
> [...]
> 
> > I believe I've addressed most comments received in response to v2, with
> > the exception of channel allocation at .request() time for which I haven't
> > received any answer to my questions. That will hopefully not be a
> > showstopper.
>
> I totally forgot to reply to that mail. Done now. Irrespective of my
> comments, I think that cleanup could also be done as a follow-up patch after
> 3.11.

I'll address your comments and sent a v4. Hopefully it will be the last one.

Given the dependencies between the PWM TPU driver and board code, should I ask 
Simon to take the series in the SH Mobile tree (after receiving your ack of 
course) ?

> Thierry
> 
> P.S.: please not that I've switched email addresses and there's also a
> linux-pwm mailing list that you should Cc on PWM subsystem related
> patches. The info should have propagated to linux-next's MAINTAINERS.

OK, I'll make sure to CC the right addresses.

-- 
Regards,

Laurent Pinchart

--nextPart7071856.evoBBcrJJv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABAgAGBQJRueeLAAoJEIkPb2GL7hl1qTMH/1JoAGPOpSsH4Aox50hKTNqK
coa8r5Xyz5S12B1JDbOVv78/mkMD967Rmw9Eq50lzSCD+9wAYiXfJYnpI62+hlzC
g/48MtoQtGQp5c9gIAVQ2EUbl5yX+WSfWHB4ZRjvGbPo/dhp4YEokYJmGVD5K+3d
1AzTwsMy/EVwSIaoGRebEoP1pudZ5zxNNc8xT1AfVQMOPv9QuWQ+qr+kgdB5goRd
5k6nRoLn8AYtV7jtSQprqnmGrI/KfAR+QXPvUCA5ZEnleT8UXzv5EGQTVZKAv0bQ
vCTsnMKcyv1NKYgyvnR4LXyMRgi/WA8uhHlu4YOc9gF5NNNG+OeNZhIyyEIpN2c=
=u6Ng
-----END PGP SIGNATURE-----

--nextPart7071856.evoBBcrJJv--

