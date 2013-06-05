Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3FEAOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 20:14:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44719 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486Ab3FEAOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 20:14:01 -0400
Message-ID: <1370391220.21654.73.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] sctp: set association state to established in dupcook_a
 handler
From: Ben Hutchings <ben@decadent.org.uk>
To: Xufeng Zhang <xufeng.zhang@windriver.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com,
        davem@davemloft.net
Date: Wed, 05 Jun 2013 01:13:40 +0100
In-Reply-To: <51AD4A34.6050606@windriver.com>
References: <1370245978-12884-1-git-send-email-xufeng.zhang@windriver.com>
	 <20130603142811.GE7024@kroah.com> <51AD4A34.6050606@windriver.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-on7SGts9RYWWqGp6zLJ7"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-on7SGts9RYWWqGp6zLJ7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 10:00 +0800, Xufeng Zhang wrote:
> On 06/03/2013 10:28 PM, Greg KH wrote:
> > On Mon, Jun 03, 2013 at 03:52:58PM +0800, Xufeng Zhang wrote:
> >   =20
> >> 3.4-stable review patch.  If anyone has any objections, please let me =
know.
> >>     =20
> > Really?  What are you going to do with it if no one objects?
> >   =20
> Sorry, I don't have any experience with stable patch and I consult
> stable_kernel_rules.txt, there are not much special rules and here I just
> want to specify the kernel version I wish it to be applied to.
>=20
> > I know I'm sure not going to do anything with it...
> >
> > (hint, this isn't how you ask for networking stable patches to be
> > applied.)
> >   =20
> Ok, thanks for your hint, I'll resend the patch.

The heading you used should only be used by a stable branch maintainer
sending out a series of patches they've already accepted, prior to
making a new release.  If you want a fix to be added to be applied to
one or more stable branches, you should write in the form of a request.
And if you're just not sure, then you should write in the form of a
question.

Networking is a special case in that the subsystem maintainer, David
Miller, generally collects together and backports fixes for all the
official 3.x branches.  So you should send your request to him (but do
cc the stable and subsystem lists as well).

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-on7SGts9RYWWqGp6zLJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUa6CtOe/yOyVhhEJAQrS7Q/9E/wG9aVLgjIZuxfikkH0OrIvVPU5NCHH
duo9KkRTRDGI82f2E2Qcaho/Sp2cHd3uF6tSz+j7Sbu6N5vQYIIYP9CH6oWhp1oG
nVzT2HR38QKhtGMQctxwM8HRL2b1azY5npusPmnSgUTo1FFFitclIHapX2SMmPKv
1GhxmtdwoerjNy8tAw46KenLeAC4as0xdcss10MjeRjH/jcX+h5Ef6A0OsGt1wDu
NFELedtZq7MWESg2FMNol0jaBO1oBgY5w1FishQbboIucmDRROjB0ZdhJh+6RQnm
Tg6Y+3D5+n4a17epwWRak5jrnLxnVYazkzjU0mr8/ZchPRCMG0NVCQdMozM39QRe
puHE3bmnJvB51fRz+gRGnI0x3Y4A1WZhu48YanJf1/6s5fbjiaD+ve7WQg1mHFIh
yLhVN5Lk9VllVDwThNx19vJ/nDuvQEj9Ts8UCEM0YD49hFcn6lsP1rl+5dKLPuLo
GDYYjvI5OWw0BfTDEu25ULqO9Eyoyob3dTjUAVYJmp1M/wACBk3lvC2xcuPz45rX
yX4TKTW4cXaaYoe1P5pa9j2bLYKPnHWhTyOF7MjyxLQiI/xcE3TQi21zbx84FTg8
YwPCLd0MzFhyYBh4U/vwTbBs+ZpvpFbtUzTlmC6/3uC0sVB3L7ars0JnB66o1hlo
jzS3I7DhOys=
=/v8h
-----END PGP SIGNATURE-----

--=-on7SGts9RYWWqGp6zLJ7--
