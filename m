Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058AbaD3X3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:29:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49302 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbaD3X3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:29:00 -0400
Date: Wed, 30 Apr 2014 18:28:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Julius Werner <jwerner@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>, Jim Lin <jilin@nvidia.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
Message-ID: <20140430232847.GB7093@saruman.home>
Reply-To: <balbi@ti.com>
References: <CAODwPW9i-pwgzE-OELwwkw2M_Vnhtsq4p=_5ppO7R6xXpzu==w@mail.gmail.com>
 <Pine.LNX.4.44L0.1404011753420.8643-100000@netrider.rowland.org>
 <CAODwPW_N9sNKCcfD9ebGgCW71+zN_Ge9OM9uq7eRwyxgfyu4Uw@mail.gmail.com>
 <535FDE71.7000601@linux.intel.com>
 <CAODwPW_wpG3Xupfgfzi4LeYukL6qOFNkK=Zg9Ks7sjRA5y450A@mail.gmail.com>
 <1398793097-2805-1-git-send-email-jwerner@chromium.org>
 <20140430230424.GA5880@xanatos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <20140430230424.GA5880@xanatos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 30, 2014 at 04:04:24PM -0700, Sarah Sharp wrote:
> Hi Mathias,
>=20
> I tested both this patch and your global command queue patches on top of
> your for-usb-linus branch.  After reverting commit 400362f1d8dc "ALSA:
> usb-audio: Resume mixer values properly", I was able to get my USB
> webcam working. [1]
>=20
> I wrote a small shell script (attached) to start and kill guvcview over

-ENOATTACHMENT :-)

--=20
balbi

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYYcvAAoJEIaOsuA1yqREwNkP/jjL9Q8V0XKf2p2xubGDG0WT
qwLdz23i69yKnS6UKWTdDF7Hyrod8ku5Ck8k2dSqQV/7lXKa/F8kvG0J2MjOdeG+
+NiYCZRl21lRha4ShRZZ9P64qx3DmTm7k1vrUkKg0W6vjHkg6iJIqwgo4m8LNzTf
aMJS/9+yU86SvyHWBcTz9QaDbg3IydgAEHRnyCSiFycs/burKg6JIZI5PyahfrK7
5OkD4xLyLGDe+3WGTLMRFVPCWqsiyZAsbE8Ol4I5m7QPLy9p59GHRt6U7zsNXJcP
k48bVxAgpwIeXnfxi6gGuzoyTt0AE7EhBCRuPfJoG90eZWhcUJ+63aQN8yNvovg1
RrI2hrtRQEvP/GiX0EIJ50fqmZtdPxeZjHELvVY3eMuTMWWW7YOWdLXJv4/BZ7nG
zI49YdscV0byFFovdnGMV1kEyGcQr+I44KZAh+j9bCJE381z3IGqFTOMwAVN6w7f
zlAVG7eIDNiqHjclhFDoUAhzp3GhJy5X9dqFVRd9d3jOxyTS/sKYTeg7ZfJVoiac
ynFlzYysCnXgzBmmrTkZhwheDzHN622UgnTxWNUGSITIbxIISmpJEFm9HFdkfrzM
Ppqom8xwoB/etyTKBNgxGK1or54vP6Nz/e2PCVo/icqjvnNZgsc0q/B81ZomDclm
f4ya+Ox+VPM3EbecCz4+
=aG8F
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
