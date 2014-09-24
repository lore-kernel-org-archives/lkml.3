Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaIXXP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 19:15:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40134 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaIXXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 19:15:56 -0400
Date: Wed, 24 Sep 2014 18:15:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Sojka <sojka@merica.cz>, <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v6 0/4] LED triggers for USB host and device
Message-ID: <20140924231550.GC27672@saruman>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <20140924205936.GC17997@saruman>
 <20140924214155.GA30689@kroah.com>
 <20140924221830.GA27914@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <20140924221830.GA27914@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 05:18:30PM -0500, Felipe Balbi wrote:
> On Wed, Sep 24, 2014 at 11:41:55PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Sep 24, 2014 at 03:59:36PM -0500, Felipe Balbi wrote:
> > > On Wed, Sep 24, 2014 at 10:43:17PM +0200, Michal Sojka wrote:
> > > > This adds LED triggers for USB host and device. First two patches
> > > > refactor UDC drivers as requested by Felipe Balbi, the next renames=
 a
> > > > file and the last is the actual implementation of the LED triggers.
> > > >=20
> > > > Changes from v5:
> > > > - Refactoring of USB gadget completion split into two patches (Fili=
pe
> > > >   Balbi)
> > > > - Removed check for non-NULL req->completion (Filipe Balbi)
> > > >=20
> > > > Changes from v4:
> > > > - Added performance numbers to the commit message of the last patch
> > > >   (greg k-h).
> > > > - Replaced BUG_ON with pr_err (Alan Stern, greg k-h).
> > > > - Used proper coding style for switch statement (greg k-h).
> > > > - Added comment about NULL argument (greg k-h).
> > > > - EXPORT_SYMBOL changed to EXPORT_SYMBOL_GPL (greg k-h).
> > > > - Both triggers are now registerd even if host or gagdet subsystem
> > > >   is not enabled (Bryan Wu, greg k-h).
> > > >=20
> > > > Changes from v3:
> > > > - usb_gadget_giveback_request() moved outside of CONFIG_HAS_DMA
> > > >   conditioned block.
> > > > - Added kernel-doc for usb_gadget_giveback_request() (Felipe Balbi).
> > > > - Removed outdated comment (Alan Stern).
> > > > - req->complete =3D=3D NULL is now a bug. Previously, this was igno=
red
> > > >   (Alan Stern).
> > > > - File rename moved to a separate commit (greg k-h).
> > > >=20
> > > > Changes from v2:
> > > > - Host/gadget triggers merged to a single file in usb/common/ (Feli=
pe
> > > >   Balbi).
> > > > - UDC drivers refactored so that LED trigger works for all of them.
> > > >=20
> > > > Changes from v1:
> > > > - Moved from drivers/leds/ to drivers/usb/.
> > > > - Improved Kconfig help.
> > > > - Linked with other modules rather than being standalone modules.
> > > >=20
> > > > Michal Sojka (4):
> > > >   usb: gadget: Introduce usb_gadget_giveback_request()
> > > >   usb: gadget: Refactor request completion
> > > >   usb: Rename usb-common.c
> > > >   usb: Add LED triggers for USB activity
> > >=20
> > > Greg, how do you want to handle this one as it touched both host and
> > > gadget ? I could wait until you apply this series to your usb-next and
> > > based my pull request on that. That'll work as long as it doesn't take
> > > too long for this to be merged.
> >=20
> > I can just take this now, for 3.18-rc1, you've already sent me your
> > patches for that release, so there shouldn't be any conflicts, right?
>=20
> that's better. Can you wait 1 day though ? I can run these through my
> build tests.

running my build tests on top of v3.17-rc6 + these 4 patches. I'll
report back tomorrow. From a code perspective, though, they look
alright.

cheers

--=20
balbi

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUI1CmAAoJEIaOsuA1yqREj5QQAKtpz6MuM3WM/rYQly56y/+s
8O14N5/vgptpV9UQL77IxEWjaOK61bGWCZ8meVF0S7Fcsuoefg5P0uJhEFre0a/k
p+plwD1HOXGrrUI854ZG9HXrkMFx9loFte6yXXT2mmr0rhv2Ua7VKTx+E63eyIvJ
+S26iqLNcV1m53rpyQYffoMIF9b7ybj3vcBtindNiP7KeHD+c3XC/mk29zFZBETU
GvcjvDsR1ZIh0+gVkGxoG2cn43x4Kbtvd11E7SPOfcbvvdcQPGbU5oWy/EsT0nKm
pldcfqf4TNsF2xayRpZumIBYrXgN0aCMBbECDL4C9XVB7pPlePxsUgiIQey1ANs4
UvSZ41QwlTVDCSqPcFdQDOnoA99EMkhgNF2T/RgJEBFBhGnOEPxYVbpIiLcPZDhB
WPIQJ5J/xhceLaOaW+iLGo3rVeAiq6UM0mzf03SnU4A7RPQnFjq0Go5JpTUhzhxK
VuJCmQ9dNK12oPDuG6yndXY2HfifFbrvD6igOzYoL+jDfo3uuQBAuYjjSbp4hYmn
3KcCffNKrR8d4XJWTExn1JK5D2DAKtxgbpQH02BHw3gCvcl5M57eWtDSVynfkft4
ndbPeZ0L/yrnNQZtdd5hlBXP1iqulXwjuXVhhoxdBhU13Ne90dqk5m92/Gzrydo3
X75QY9+/ZeNZSKzfhgUv
=ij49
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
