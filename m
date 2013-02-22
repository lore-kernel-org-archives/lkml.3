Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3BVGrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:47:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3BVGrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:47:13 -0500
Date: Fri, 22 Feb 2013 07:47:08 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130222064708.GA30458@avionic-0098.mockup.avionic-design.de>
References: <20130221184010.GA24692@kroah.com>
 <CA+55aFwjbGRvGHhQQ7vUYP+wChp_ZBQ54ZFxzrRjTkdffcteWQ@mail.gmail.com>
 <20130221215839.GB28131@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20130221215839.GB28131@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:RBcjdsXkNUhDEwdBpQOLvFwEqagtCakhynKm3svBqkM
 kx8LsRtSLKYPXMat1HKv4jHRfGNi1/5djnqbr5CBJm6bm0B3tn
 Q0nqeb/ZSNrA2SvlAsVWMXUFpTXqCk2zRw9S3i1NMmEu6nAlwS
 X/PT+A20wBHUDKhlZOOvj+PRcqdYYwIR4Wup1aHn7cDawTD0dL
 xwDss+Ho4hOxO9Xh13RAd/t8+csBjelmgeYBJGSJmZz6pfcKKa
 4uuTdFrqGuGf6/l1c8wu2mEy94X1zTD3IPOFDTNgccMzVt+LVq
 Qk1sV59wl+zjf+b/KHMuOx/NJEhEpL8bTIDh/dmAin4hlDYpeZ
 h7qsq7iiI5IJ2BNyz/YY8FZCIThhSL3tTyvOi6PNHL62qVLORk
 mhajhHZuTtpHMqHJphtkPUfh7dYHjuN/SSzRN34Bxk8c5QTOzb
 Msm2/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21, 2013 at 01:58:39PM -0800, Greg KH wrote:
> On Thu, Feb 21, 2013 at 12:25:24PM -0800, Linus Torvalds wrote:
> > On Thu, Feb 21, 2013 at 10:40 AM, Greg KH <gregkh@linuxfoundation.org> =
wrote:
> > >
> > > USB patches for 3.9-rc1
> > >
> > > Here's the big USB merge for 3.9-rc1
> > >
> > > Nothing major, lots of gadget fixes, and of course, xhci stuff.
> >=20
> > Ok, so there were a couple of conflicts with Thierry Reding's series
> > to convert devm_request_and_ioremap() users into
> > devm_ioremap_resource(), where some of the old users had been
> > converted to use other helper functions (eg omap_get_control_dev()).
>=20
> That's fine.
>=20
> > I left the omap_get_control_dev() users alone, but I do want to note
> > that omap_control_usb_probe() itself now uses that
> > devm_request_and_ioremap() function. And I did *not* extend the merge
> > to do that kind of conversion in the helper function, so I'm assuming
> > Thierry might want to extend his work. Assuming people care enough..
>=20
> Yes, his plan was to do another sweep of the calls and hopefully remove
> the old api in 3.10 or so once that is all cleaned up.

Given that even devm_request_and_ioremap() is rather new and people have
been busy sending patches to use it I had expected that the initial
series wouldn't catch all uses once it had been merged. grepping is easy
and I even have a semantic patch to help with the conversion so I'll
keep an eye out for any new occurrences.

Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJxRsAAoJEN0jrNd/PrOhjaIQAMJWjGWsqrt7q5r8HHEHftgq
VcIe8bO7oheFSWmrdaozVCyK9kSYEoSk0HgWyGLIoEKLohz2RhtwYk454KIExSD4
LrwIe4l4k299Jp9gPsRaKrwR8IyjbEb9s3QiipzWi17lkb3z84vsOQJKQ/h5jRk4
XArbNu23HwO5dZD6L18UzPEYAFr/uyBefX7jFGGfYFZOmeaGfehab9oRb6YmI5iw
MyJ0cd5sCRc2gJX9HJ466Vdk0wvgtfwCFyrjpNMgktTfBw3gW1e5LwzZ2s1aUwVO
Lxi/LoXdZmrD9nZ3VrKxyIWAoysuaYi0NjKEKMKkZv+HSin/v2Q8l4zvGjqaf8/v
t0DQExcyCGgLY3PUcFRAtObvB9Q3iohU3mowFSGzt0iH4uYIC/aQQbxXu1vSMfGu
WU4yMCuSoc8abhGs+QDwH4jx1R9bl8QxOy19A4/v+cnXHu0pCJ2xmQ7kj7tl4oiF
bImEazH1No+CX608TQ90jInss3e87zVVqhQzu31mkLrGRb0QRpHSlWCBRBmlbz/1
jPUv+S+vy7rUySdWEUIKa7TE78I1lApq2D2I+wK1qgVcjTTMJWbpmIOZ3Up3nDyJ
lyqGgJ+vfCpNQaSwRcclG8o34ZeN52lfi01ngLy3+pYAMhVDOfvuRECV7oqokoTh
m4MAjJEVKlobCU/nJG97
=lLvO
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
