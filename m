Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3DUXL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 19:11:29 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53106 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3DUXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 19:11:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] uvcvideo: quirk PROBE_DEF for Dell Studio / OmniVision webcam
Date: Mon, 22 Apr 2013 01:11:20 +0200
Message-ID: <2645710.Gpj91p3W0i@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366216723.20385.7.camel@fourier>
References: <1366052511-27284-1-git-send-email-kamal@canonical.com> <3233904.U6nm1cedXx@avalon> <1366216723.20385.7.camel@fourier>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7389361.xNRVaurBPr"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart7389361.xNRVaurBPr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Kamal,

On Wednesday 17 April 2013 09:38:43 Kamal Mostafa wrote:
> On Wed, 2013-04-17 at 01:05 +0200, Laurent Pinchart wrote:
> > Hi Kamal,
> > 
> > On Monday 15 April 2013 12:01:51 Kamal Mostafa wrote:
> > > BugLink: https://bugs.launchpad.net/bugs/1168430
> > > 
> > > OminiVision webcam 0x05a9:0x264a (in Dell Studio Hybrid 140g) needs the
> > > same UVC_QUIRK_PROBE_DEF as other OmniVision model to be recognized
> > > consistently.
> > > 
> > > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > 
> > Thank you for the patch.
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > I've taken the patch in my tree and will submit it upstream for v3.11.
> > 
> > Could you please try to get the full 'lsusb -v -d 05a9:264a' output from
> > the bug reporter ?
> 
> Thanks Laurent.  The requested lsusb dump is now available at
> https://launchpadlibrarian.net/137633994/lsusb-omnivision-264a.txt

Thank you for the information.

-- 
Regards,

Laurent Pinchart

--nextPart7389361.xNRVaurBPr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJRdHInAAoJEIkPb2GL7hl1PJ8IALT00s4t2Ac0awsAbZQB1ID2
fW2EEzGt38ixPMdPX/Qa5iwYjQlrQXBQorwA1g9oGfmaMFLuZBCTnTpNwnRGL2CT
5P/P/cRb8bHeYHjEBQ8RfjGkzVj53Vamj17VrK3IBWDo58XVujXTq8H+XoH7/DBT
znZa8jlD1cY/aML8rAm6rW6oUA1LtDjrczhUb9vPSxz3GPrd49chuD3mFNlQcgqC
b4pu2sWD8yeHI4ZYm4m6HcF8S8L/qFrvIajmK8q0YN55yLQeBf3fjEc1X4V0bdPP
PUKWPeDlDzzYfZbQGBcLQLbe0IZxh7Zz+NcjWrOhHyv0ll/VRpD1FMhc4fgcjBY=
=6NYv
-----END PGP SIGNATURE-----

--nextPart7389361.xNRVaurBPr--

