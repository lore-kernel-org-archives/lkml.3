Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaCUOqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:46:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41575 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaCUOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:46:07 -0400
Date: Fri, 21 Mar 2014 09:43:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Felipe Balbi <balbi@ti.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: boot: dts: build keystone devicetree blob
Message-ID: <20140321144328.GC12310@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394639330-1288-1-git-send-email-balbi@ti.com>
 <53208CDD.7030106@ti.com>
 <532C4F40.5010903@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Content-Disposition: inline
In-Reply-To: <532C4F40.5010903@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2014 at 10:40:00AM -0400, Santosh Shilimkar wrote:
> On Wednesday 12 March 2014 12:35 PM, Santosh Shilimkar wrote:
> > On Wednesday 12 March 2014 11:48 PM, Felipe Balbi wrote:
> >> Currently, even when building keystone only
> >> kernel builds, DTB won't get build because
> >> we lack a Makefile rule to get it compiled.
> >>
> >> This patch adds that rule so mainline kernel
> >> users have a chance to use up-to-date DTB on
> >> keystone 2 platforms.
> >>
> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> ---
> >>
> > We have been building dtbs with explicit command
> > instead of dtbs since it was just one dtb so far
> > supported. Was planning to add the rule once more
> > boards get added. Now with Lamarr and Edision in
> > for next merge window, will do that post 3.15-rc1.
> >=20
> Just to close the loop, I added a patch as part
> of my 3.15 fixes which builds all keystone dt
> blobs.

cool, thanks

--=20
balbi

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTLFAQAAoJEIaOsuA1yqREXFcP/R4yqPwfWn9XJOG2KoL1MBDE
ufKpq1yOjk+jEeNj5Ph0dj4pIMA7+WqA84f88kkftKDjaF/90sYxlfYuobKCVqzZ
PtfwKajjZvGoQq70pNk+hEPfADUD4t5tDjPQG5he3rW0vFbG2ugppBe8/cG1wIcK
93o60cnLX9PtKEB+rdKx7gCQeXJU6Xf0iKWzvTrbNzMYD8tkywUJbtB0LK0CIS5h
IDqxRZE1riRZj4v5LROmWEjFV0pgBf+SJhHYlqOGvOmhCyv2VI3LCCYuxTbNI9NJ
D15+SVq0N10U3h1bMKk0+O5tf/DN8gzHfs19HdRFi47tqqOwPEyzoId4tP/EYHRC
juNsb4iwiEr9wUh9hxhkk5DwzYFWQMiam7tHvl536OUbSjh1x4iSEa/BgTMYstrl
VMqXrtQxfp29n4DHd3cCehz+XFNIoS3T2HXx49bsMA8BX4aE/9SfoI/a1TOq+vyB
u+sSET7pjegJ1Kyg4OJsxtYArIZdKn3jhVRTvv3oWekK9u85CeZHbW36XbtuuRqJ
ORXRfcyjUKIWdzs7gbcWAEBtHDzjZCaveC8PT+Ud2J5FfBVp0rd1hNG9XB4eYOVQ
Fv0C2ofaC1xuqEgaUk5bZem2uKTap4NL6mfQn+qRof3QkK4XUUmADhwwxWqYY17Z
eBvfxQ93ztUPupz2Z3Ld
=xYn9
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
