Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaJ1Snd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:43:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39295 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaJ1Snc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:43:32 -0400
Date: Tue, 28 Oct 2014 13:43:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 13/19] usb: dwc3: add tx demphasis quirk
Message-ID: <20141028184303.GD25735@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-14-git-send-email-ray.huang@amd.com>
 <CAErSpo6ouE7AZi8ysTFnTNtKc8R9w-71AhXe6b-_0g_yeR-=Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <CAErSpo6ouE7AZi8ysTFnTNtKc8R9w-71AhXe6b-_0g_yeR-=Ag@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 10:27:27AM -0600, Bjorn Helgaas wrote:
> On Tue, Oct 28, 2014 at 5:54 AM, Huang Rui <ray.huang@amd.com> wrote:
> > This patch adds Tx demphasis quirk, and the Tx demphasis value is
>=20
> "demphasis" (above and in subject) should be "de-emphasis" as used in
> the code and comments below.

+1

--=20
balbi

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT+O3AAoJEIaOsuA1yqREQ7cP/1n5lPcUZgKDXYQqRrnzJC8U
vmq/0HGHGZAeXGGoIoHI2vk2d8FrWXxRFeks2PQaBZHSJJMGNp7U0Zm4dC6x95qm
5G3ydfsLWNlJV0nJZdMLycwgeO38xekWJQbb8eq2cpvqfl9BHDkaurgIg8Z/3y7X
MYuyiLkunxbzf9hmv66Mt5/BynIsy8sTnRmzEELnwxQKPKwavU8RhVNiUQn9p+mb
+WJYv4hhviGU+yo7fmTbh+Eu54HB0qOsm9n7bI6bMOyfyzvVF5fOvX+YGHN4oK7g
7ds+DwtEVz5r/NeDl7q0iVXtLMytwmF1sPcKX24xcpvFhWDl/Z6KR4KZX3WRXZze
hc6uxcbw2M2YHvxTOWDLscOqq242Wxm4g1FEL0uxZpCotkJzvuEB+0is4w9udN9R
D6RRenvr/lMpp1eVKU1GQ2YzOTZkEVl7UOQfS7WbdLwYI2qTYOcZ3WEbIbgo3J5h
i5rrQSlb9K2nlbARqrNmW93c/szoa9+BtWGv+70ibSADdeI3CGJd6kH3eDXC3SD5
SmBaERLCp4Gc5cJAAiCv4napevISyI583Zvh/Z5PmlIfHBwR6ehUM4iJH7vj6lBX
tkNno8OYWz1VotAra0gm/VKEB7NfqKmkNWhiiSiwU7syhnW4kWG+cXmWrAwoReKb
qNaER2KTifbmj/l2WEs7
=2nfR
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
