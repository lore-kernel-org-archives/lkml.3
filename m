Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaFINXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:23:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43169 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbaFINXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:23:01 -0400
Message-ID: <5395B52A.1030701@ti.com>
Date: Mon, 9 Jun 2014 16:22:50 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
CC: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 5/5] drm/i915: Kick out vga console
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>	<1401980308-5116-5-git-send-email-daniel.vetter@ffwll.ch> <CAKMK7uH7GWspr03NBi7rVY+2UN-vdthMV7eixXA-xc3t2JdzPg@mail.gmail.com>
In-Reply-To: <CAKMK7uH7GWspr03NBi7rVY+2UN-vdthMV7eixXA-xc3t2JdzPg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="EKBw13oRrsdqiu7N34pkQGEaqLSp2ug57"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EKBw13oRrsdqiu7N34pkQGEaqLSp2ug57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 06/06/14 18:20, Daniel Vetter wrote:
> Tomi/Jean can you please ack merging this through drm-intel trees? It
> just exports the vga and dummy consoles so that i915 can do what it
> needs to do.

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--EKBw13oRrsdqiu7N34pkQGEaqLSp2ug57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTlbUqAAoJEPo9qoy8lh71sDkP/RDL7eH9cPpWkukLNES6vS16
22pbbhAn6hPFZwzeGPlKZ35po0F7VwsIFyZJ8nGM4Tn4PlFF17dlyxdDQZkNu1yV
FE6oX5WLlB9KddJBnrM40l2AxN3Q5hQaBV68oa0Uwv565iRhlhRC2mRUHRngp8ch
nEmiWBUA3CkmAD+ar3v5Bph4YWUIrNiXw1CloFv6jg+7uoI8s3QJWEhzY4aPOHLf
8T58vHuEkeWU5VZ3JYAWyaQUdnSeyRI57QNhYNi4D+4CrIxjp45PcZ35Fi0iA5tt
WCYPXII5LXedZ58kL7GrqNK8mPPj5zfKY7nQ48wQZWE9E7uAm17FdhH/pVz7VvnG
bYeF0+br5enOhOi9rioMRQGxx9PJJ6YlDeAhYWkKZyR9VIU0/SmcsDodGhx6wsJ9
s6qf8SUPpH2WFJ3hI6/Bu9sBwvaTJF+m/bU7aONIPmakPjKW5ra5aYThaBrXMnbz
10EwrWNlOVQcIkbZAqccUFW54reMKFhh2aZEe6YgsJ2IC/D/fa/sw7pCFcnGlAc6
kwrzLc2UTnc80Hgq+/S7jL7khkEa11WJ1Xf3UKcVA/cjipzLwHpT9Sr/Rvn4Rg3B
OEhJaHxBx/DZhzvV2gPmkZH7WP6msKsl6G4a+S726W5OEoS26TB1BRGdOGWXqlH6
/G9T1aB4mnvLnfTzbWax
=6era
-----END PGP SIGNATURE-----

--EKBw13oRrsdqiu7N34pkQGEaqLSp2ug57--
