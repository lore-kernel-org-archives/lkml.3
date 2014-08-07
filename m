Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbaHGN4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:56:03 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53961 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512AbaHGN4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:56:01 -0400
Date: Thu, 7 Aug 2014 15:55:55 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH v2 00/11] pwm: Introduce ST's PWM driver
Message-ID: <20140807135554.GB27417@ulmo.nvidia.com>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
 <20140721123950.GY30888@lee--X1>
 <20140807132050.GC1540@ulmo.nvidia.com>
 <20140807135432.GB21618@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <20140807135432.GB21618@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 02:54:32PM +0100, Lee Jones wrote:
> On Thu, 07 Aug 2014, Thierry Reding wrote:
>=20
> > On Mon, Jul 21, 2014 at 01:39:50PM +0100, Lee Jones wrote:
> > > Hi Thierry,
> > >=20
> > > Did you find some time to look at this set?
> >=20
> > Sorry for the long delay. I've applied patches 6-11 to the PWM tree,
> > though I've modified patch 6 a little for consistency. The module is
> > now named after the Kconfig option (pwm-sti rather than pwm-st). The
> > dependencies also seem to be redundant (ARCH_STI already depends on
> > OF), though I didn't change that just in case it's required for some
> > other reason.
> >=20
> > Anyway, scream if there's anything in the PWM for-next branch that
> > needs to be fixed up.
>=20
> And in time for v3.17.  Nice one, thanks Thierry.

Barely...

Thierry

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT44VqAAoJEN0jrNd/PrOhn8YP/jjR9coULS8sfNmgATFZNrhj
Xmsu3crBeAgNk9+bIYulFhI7cqsHvSp5LYA2AMM102753YluXJhwt0K1LoJZiYk8
tpRrqrfG+whKjiG2aQscWVTGHddmnjHLQF8Lco86s6ML4RT++QGU2mdDOkXQMlE8
nX8BtcKqDW+DOfiyH3/TQyR6L+hUJDWmoSTzp0qYJLpLa2ZjoDmOdzfFXTc3TJE/
jAuzfoUA10sfqeMPmRerjJcwVFPWr6OJiIZf3M4Nc8feJNxfYOzmkMyVMm+Je7l9
7SuILTwnPGlp4hF5mpLnhK1ar9AVnzAzGTH4vSomveWHTH74D4BIQOTLJt6qHS+T
8SXCeaBxq4GUUNTHOUxrD8hG9VlqNxfBewOhzluaDNFJ9qmTsr5Fgf4JQaia0eRD
dpKhUill9BikdUJqE0/dQXOUTwjCAnSMbn/vdSBccDMrV6wW0dHP5y2ALEPIo9vo
sc8i/acT4wGZpNkNBxGNIKUVejBwshyN0ZW1ea6rnk2CqQE4iX8RhRLlFUF5ziEs
AHARJogM3sYNdUluLAg8xWg0gLjD4wRInpZ8r/dMzgccxdFqekOgaIEbdrJ1rPHM
qYkxRznzksN/1TaOISpWZn5IdJM/g3sZwtddxJYsGQJp9WfWJqEPzuN22tiovtCq
cbupTbDlu0dhvicWVHyW
=mzHW
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
