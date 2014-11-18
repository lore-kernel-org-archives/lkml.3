Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaKRQlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:41:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50025 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaKRQlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:41:03 -0500
Date: Tue, 18 Nov 2014 10:40:07 -0600
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
CC: Felipe Balbi <balbi@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the
 driver-core tree
Message-ID: <20141118164007.GC6179@saruman>
Reply-To: <balbi@ti.com>
References: <20141118181222.451b84d1@canb.auug.org.au>
 <20141118152531.GD8223@saruman>
 <20141118162436.GA1108@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <20141118162436.GA1108@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 08:24:36AM -0800, Greg KH wrote:
> On Tue, Nov 18, 2014 at 09:25:31AM -0600, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Nov 18, 2014 at 06:12:22PM +1100, Stephen Rothwell wrote:
> > > Hi Felipe,
> > >=20
> > > Today's linux-next merge of the usb-gadget tree got a conflict in
> > > drivers/usb/dwc2/gadget.c between commit 7c3e90537b74 ("usb: dwc2: dr=
op
> > > owner assignment from platform_drivers") from the driver-core tree and
> >=20
> > why is that commit in the driver-core tree ? It wasn't even acked by
> > Paul Z. It wasn't sent to linux-usb either.
> >=20
> > Sure, it's minimal, but I'd expect a little cordiality in Ccing driver
> > maintainers ;-)
>=20
> We fixed up many hundreds of drivers all at once, it was easier to take
> that change through my driver-core tree than try to coordinate in
> everyone's different trees and end up missing some usages.

sure, got that :-) still, no maintainer was Cced :-)

Well, the conflict would've been inevitable anyway.

--=20
balbi

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa3ZnAAoJEIaOsuA1yqREKtgP/1QJwSZCRCJu+TrheRFvkiME
G4vxg4cSx62oCq2GVinhMuIiw+k7AyaZh+/LHjGrEFuQCS3bzzYVihSF3Lj8rftK
K/yPmiPtn8dSIp12nRKVvvBi0v/RQmmezHZF/n0ZvJme+5JLOGpkiFM+oF1arMnD
oHjJ+Hgo6PoPbe60sf/DGSu/uOyLFaosmvph/scFwpKSgaM0JxAGSCRJILu1Rigk
SJxFATCVXPYAigTSfPGONRb82N07SHzuPCBunsyv8V5KjRvEKNCWvr88QSN5b3Tv
87XE5pDF67vNlLUPpwg/4FGfvfBBFlk/pLkAxOC0+c/QkDtMl//rVONK6JDIZT5A
3y5trCztlCz+C/uKBQvCNLeGESoZpQ/Jq+pN3bR0SuqtggTBJxjllQuUTvYECHXG
Dsa4C2PCZARJ3lsCovgcbgqjdaTonaSMFzgy27k9LCdKhYJsoGLpQK6FeMxyaGVm
7weQ7mhZYGowj0Oiqx80wK5cLLCLCDTSdUMDsXAK72YHpV6xZfS+p3c5h+RNIZ93
MyHbqb8kqdZrw2q2bsUCqWhyXIFW4DeS2VZp12tDDngWTxWBdOhXOl86ukAytKv3
k4pcRq2aLlGtGPhNddxFFjx+PQcchKAlY4yKEqqu04B44z8h41jKNeyJ5Q18G24C
vBCnqhNmf/+Ju3NQDZJz
=Y0a6
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
