Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaGQRX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:23:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44017 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaGQRX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:23:56 -0400
Date: Thu, 17 Jul 2014 12:23:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <Peter.Chen@freescale.com>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] usb: add support for the generic PHY framework
Message-ID: <20140717172335.GN10459@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140716174513.GF3016@saruman.home>
 <20140717080302.GA3090@kwain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GEn4szYucjS2InE7"
Content-Disposition: inline
In-Reply-To: <20140717080302.GA3090@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GEn4szYucjS2InE7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 17, 2014 at 10:03:02AM +0200, Antoine T=E9nart wrote:
> Hi Felipe,
>=20
> On Wed, Jul 16, 2014 at 12:45:13PM -0500, Felipe Balbi wrote:
> > On Tue, Jul 15, 2014 at 04:39:08PM +0200, Antoine T=E9nart wrote:
> > >=20
> > > [1] https://www.mail-archive.com/linux-usb@vger.kernel.org/msg43471.h=
tml
> >=20
> > Since this has a dependency on the other series which hasn't showed up
> > with enough Acks, I can't take this one either. Let's get this ready
> > early into v3.18-rc cycle so we don't miss this and the other series
> > again.
>=20
> Since this patch does not differ a lot from what I proposed, and is not
> that big, can't we try to have acks in the next days so that we can take
> this series as well? That would help my Berlin USB series[1] which
> depends on this one :)
>=20
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/27284=
0.html

my tree is already closed for v3.17 unless it's an important fix for
what's already in my 'next' branch. Moreover, I never got acks from
everybody necessary. Sorry, it has to wait until v3.18.

--=20
balbi

--GEn4szYucjS2InE7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyAaXAAoJEIaOsuA1yqREqawQAJrwp3KJ6t7ARiDAgFr++aaj
MKQ//irw169Itk3b795WMQ4Z9LeAOxb5FU506FF1FzOsICJxxRIoazqLbriPRrUp
2MMNf399w6bYhSMIjGr0Ep/OjKqYZOQUgruxZCPxdU4pHjFSgL/lhzUZmeCyv+7v
dm/IjvHVHjmc39vHMU7DJFVcHdU6NK82kKi8VVy14HhUwsHVbQz4QQuxs1ObEyl8
rVkaxs8eDl+EK6YOpXX5/VgXNDqTeyCYxt4nWW2hO3pCMnZKQNHFinvuXIEHzyto
RwhFittPG0888QHR22uCSXU4+wLq5bhYNNJjuw57GcEatrJmcBKu6l7lrRPWj2R9
3k361pzj45U3lSfVuhZ1QypmKmjUg8zT8U4iRAWy0P02hcyGUKQoduvxD40OPERF
qTgA4LYqngPuDvquF91r+gqpz77RgEZlq0MhMzwWIpevBalVRhbFfOT7KdzuoIGi
uqhGdyeUIsAWj4qAcxvleThCqFMZZ8di/vn2MkxuLataP4QArK13+ugUGt4+1kkq
Kf1uROkW07CrO4vSgNs4njZBIJjrqE1CoYsCVbor0SR2FLkYdxQdMlsua9J40myN
oEh+7kVdcnPQcxW8ba72u2LFM4Q/gI3DPaD+ChIOtMxg7BQA3/zPjn5zkfNxo+VA
7omByZoVoWWw3SapAyrx
=n/sk
-----END PGP SIGNATURE-----

--GEn4szYucjS2InE7--
