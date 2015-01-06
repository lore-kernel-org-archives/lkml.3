Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbbAFWrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:47:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45848 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbAFWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:47:46 -0500
Date: Tue, 6 Jan 2015 16:46:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Pavel Machek <pavel@ucw.cz>, Felipe Balbi <balbi@ti.com>,
        <pali.rohar@gmail.com>, <sre@debian.org>, <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@kernel.org>,
        <ivo.g.dimitrov.75@gmail.com>
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106224622.GA13752@saruman>
Reply-To: <balbi@ti.com>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
 <20150106205730.GA6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106220805.GD13902@amd>
 <20150106222717.GC6071@fuloong-minipc.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20150106222717.GC6071@fuloong-minipc.musicnaut.iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 07, 2015 at 12:27:17AM +0200, Aaro Koskinen wrote:
> But I'm mounting it from userspace (using builtin initramfs inside
> zImage), with a poll loop that waits for a device to appear. Maybe if you
> do it from kernel you need to use root wait/delay etc. options?

yeah, rootwait should do it.

--=20
balbi

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrGW+AAoJEIaOsuA1yqREA44P/1VsrUxVdUzjtF+OPMG4Rn6G
nDQWodGoelCwTtSos2lJKqE1fK6cdqDxaYxfEW/6RHPyQKbVNFFqdFJ8qTsFPQK8
QV8teGBj7PDkFkJ+DOIuWu3ZgSXSll2kmtvgCg6MW4IJ1sdKBvCj8yCWVl/oJVwB
56M/jsbQk91nKGttwDddYPz2wFkV0z5pGOA/3Mc8vSN+VuGAOcIlvHDjjCvpOFyC
N5EMyZ9HKeWe3YdMnrGaYARAlzP/fMFCe3BxdyXSOWVukg9xqVOIOovsEmOrRyOA
GNZZB36asBtD0TB0NM5CmuckyiIPk4AADCqWscwqXdrh69wJ/wAii+MuOuIbRzgx
U8skt2k1K603hl6W/ihQmfWsW3lVyW7azPquvYYOzgV0YUDk2DFBZjabqPl3qOC2
f9NgcPrBedN3pe/Jd24SwYi+Rt36QpwwRSQVov9opjs85kY2kFVeVOP2CguIqMQv
RvTWeSIR0lhZGUw11ddbwsTnxcwUh7vlRe1h78w0yFotlVotzM5vkZE0hpldEvUQ
N08rZKNYat7Sz0QpZeP3MTjf1IJs6WZ1BPmInNoZhA/Rdo7v5TwOJzy+U+naP9EO
Y/ek+Aet4MK5TheZVgJQ3zt1i2Uv6nQ2cZQQK+urhoYBtOgPjQJ2zZMXSln6GYJ8
3ZHawDsPSpj6ZIPKkRCz
=kyr0
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
