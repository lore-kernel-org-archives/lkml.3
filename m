Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3FMPjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:39:09 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50203 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3FMPjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:39:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@gmail.com>, linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3 1/5] pwm: Add Renesas TPU PWM driver
Date: Thu, 13 Jun 2013 17:39:15 +0200
Message-ID: <2443882.iHzYTamhi6@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130612102223.GC30841@mithrandir>
References: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1370958344-19470-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20130612102223.GC30841@mithrandir>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1558713.3lfVaIhsMj"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1558713.3lfVaIhsMj
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Thierry,

On Wednesday 12 June 2013 12:22:24 Thierry Reding wrote:
> On Tue, Jun 11, 2013 at 03:45:40PM +0200, Laurent Pinchart wrote:
> [...]
> 
> > +static struct platform_driver tpu_driver = {
> > +	.probe		= tpu_probe,
> > +	.remove		= tpu_remove,
> > +	.driver		= {
> > +		.name	= "renesas_tpu_pwm",
> 
> You agreed to rename this to "renesas-tpu-pwm" after my review of v2.
> Can you please fix that in the next version. It's the only remaining
> issue: as I said, the other minor quibbles can be fixed up in a
> subsequent patch.

My bad, that slipped through the cracks. I'll submit v4.

-- 
Regards,

Laurent Pinchart

--nextPart1558713.3lfVaIhsMj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABAgAGBQJRueejAAoJEIkPb2GL7hl1DfsH/RYYEYqZf/GJLFJpn6NysMVT
rivkUAaXA0QgaUBSik63PTc61peFpnqPfqCq6ceBf7NGK6i0MmzR+fVlyFPaLr1C
16l8l2hrYBVVzxnCMiIAu1mN1t2cAUWvsjjJcVkSbgn7uKcd9p6CUNNl3KbffYEb
C71WM+Ri+EIeK0wdgNoJopxtKsZPvFMQ5agJ6ovwHIrDzxDsekkmH8P0826bUyFl
tk3Nz7/LhFKm78EmHD77zcCdC5a82+BHNiFvfd8Qy8Ukv0VU8936KfrJiRCvGrhl
WqK9T3JhaM5LwO42NWt6iipeamAFMbM3ygH1371JPo/Qaimk6AOlreDjblSL3j4=
=f033
-----END PGP SIGNATURE-----

--nextPart1558713.3lfVaIhsMj--

