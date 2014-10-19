Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaJSP3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:29:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50202 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaJSP3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:29:09 -0400
Date: Sun, 19 Oct 2014 10:28:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
CC: Greg KH <greg@kroah.com>, Rik van Riel <riel@redhat.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "'Nathan Lynch'" <Nathan_Lynch@mentor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        Rabin Vincent <rabin@rab.in>, David Laight <David.Laight@ACULAB.COM>,
        Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141019152801.GC5189@saruman>
Reply-To: <balbi@ti.com>
References: <20141009210715.GH25729@saruman>
 <20141010135743.GB31348@saruman>
 <20141010162531.GL12379@n2100.arm.linux.org.uk>
 <54388B81.5020306@mentor.com>
 <063D6719AE5E284EB5DD2968C1650D6D174C996E@AcuExch.aculab.com>
 <20141013114307.GO12379@n2100.arm.linux.org.uk>
 <20141014020640.GB25433@kroah.com>
 <20141015212310.GP12379@n2100.arm.linux.org.uk>
 <20141015212513.GA3247@n2100.arm.linux.org.uk>
 <20141019095416.GT12379@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
In-Reply-To: <20141019095416.GT12379@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Oct 19, 2014 at 10:54:16AM +0100, Russell King - ARM Linux wrote:
> On Wed, Oct 15, 2014 at 10:25:13PM +0100, Russell King - ARM Linux wrote:
> > On Wed, Oct 15, 2014 at 10:23:10PM +0100, Russell King - ARM Linux wrot=
e:
> > > As I said, I have a patch in progress, but it seems that there needed
> > > to be some discussion about exactly which compiler versions are affec=
ted.
> > > It seems that it's not as trivial as looking at the GCC bug entry.
> >=20
> > ... and in any case, it has been a known bug for well over a year now,
> > and it seems that it doesn't affect _that_ many people.  So taking some
> > extra time to get it properly correct is the _right_ thing to do.
>=20
> Well, this is just great.  Pushing out the change which blacklists these
> compilers takes out Olof's kernel build system...
>=20
> Things are not as trivial as they seem.

Maybe Olof just needs to update his compiler. Olof ?

--=20
balbi

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQ9iBAAoJEIaOsuA1yqREGVgP/ifZfdXVU9l9AQGMyeUBmP31
5AqlTdKrDP6REtOYFM3o4TbwZv+iq/AgdZQCjBOapAi1PrthB+Q3I2o6rl48pTN7
BLFbOZsBPJbtixxHGVEfAgdhbxkXwjCFaXnnllaBny9PcT+U2FsemMYBBr45+LQ9
AVYfHb+vpJhNSGqLM5eaygTocleuqhXlpIWHQBnqejNZ05asRJ5hxfqLTdl04ySA
dh4wOY8ZBt5XcNZLK23YKC/XtedkApo3zx/n4NBdH9orLgoRVgh7UW4YmkXBwEMw
193zr8jUp2CDh7XPmQO2ozpR3P/ZdlW/eTagvFeKyUkodTSbLyuHoDWdZecYjDQu
XLtNFWt3YOWTB5ibpxs3qddDz3ztaBXl558n6AbG5AFLCHfWc/cwKonbgBd0vzeK
CBjnDraXiiNAssKMlHCLyOKXKDwCbwQcpWywEoBWKgeOsbGLCbhLWvHTBM50pDs5
gpFFo/5DjBYHHhfqlYV8r3OwQzT6EcP2VdNPxrGGWAjo5ACj2MjON/vsj9PdAw6F
XQnWpDhHNjALNuLZmfGApuj4tgdY8wdmOWHTm74ODA/QxU2qs4To6KLcJvJAAxoc
tM53hBSy/z+0kl5G2mpMucNYC8WxcKaxspCIoqck+fej3DfJeumfGpuCW2twW6XW
is9irIbi1RsLDMHF3nW1
=0JhB
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
