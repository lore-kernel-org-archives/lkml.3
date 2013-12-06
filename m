Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab3LFUUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:20:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44404 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab3LFUUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:20:30 -0500
Date: Fri, 6 Dec 2013 14:19:48 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Michal Nazarewicz <mina86@mina86.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5.1 4/5] check quirk to pad epout buf size when not
 aligned to maxpacketsize
Message-ID: <20131206201948.GE21086@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
 <1384201011-11114-5-git-send-email-david.a.cohen@linux.intel.com>
 <xa1ttxfiwkw0.fsf@mina86.com>
 <52817251.3040509@linux.intel.com>
 <xa1twqkdlqr8.fsf@mina86.com>
 <528272C9.30301@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KuLpqunXa7jZSBt+"
Content-Disposition: inline
In-Reply-To: <528272C9.30301@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KuLpqunXa7jZSBt+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2013 at 10:26:17AM -0800, David Cohen wrote:
> On 11/12/2013 04:59 AM, Michal Nazarewicz wrote:
> > On Tue, Nov 12 2013, David Cohen wrote:
> >> You need to update req->length otherwise it's going to crash DWC3.
> >> I'd rather to keep your previous version.
> >=20
> > That's unfortunate.  Do you want me to resend it or will you just send
> > a v6 of your whole series?
>=20
> Alan disagreed and proposed a good approach to fix req->length inside
> DWC3. We can keep this patch of yours but I'll need to change mine to
> DWC3. I'll send a v6 with update on my patch.

I rather update req->length on the functions. They own the buffer anyway

--=20
balbi

--KuLpqunXa7jZSBt+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSojFkAAoJEIaOsuA1yqRE4Z8P/Ar2sizXED2RmvDLsUgZGRIV
4zH0E6prhnvb4rC+FWWk8yCV7tVmBlvmAiJ41yR2SCVdyyohAzXQBTT1r/9QVW7K
k2cNob87qXeTPIZQ3NsL54t84URvJqkNl6yi288NOFOQkmWKrblLB2yzCdHUk9F5
puclDqO4b8kKP36GJXqUUKxWkgqftYjFPS7pXqG8bhxRTcrhwdDio/DXu00u/qMq
iGBl2jn+CcCgp27v2E2jzLTPvkW3f56DWQMZuuFRKuX4nlEuRPV6M3RwWN2j+XRy
GnfI9us3I67wOrc/IU0ErVzOFqhDrFdjf+YNGw1El4HfkEX0GSC+zvuRbJZvRx3b
Tzs9G2bpywBZJpUepJEpnZyzCK2aeYLTaqngx8zDAaEheLOYsLHlrOZH7o09uuUl
YBl8r+iI5Mrs12dGjfjaGSXiZXSi2A5FgwZEEIAwGVncgQjUaFOgE6gvdVO2I7Cq
+nGys3TAVbedxAHS55AuerRAF5G4jNmta91iNLURF7BRvLS6OhYSsE/0rwIt9SEm
5eZ3s8LmVaA4IZCUXg3bdBOY2QaLf2T5lzUSnGcPK0u82e2ykCpoBDHmzzG/JtkU
2sg1Gq9V2g2e+8KY0OYcb+VjV7f5z/nlHS9ya9/0OXOyiGN20a+56cHjvuYv5kPD
TGxWawf1MG8jc1CWNJZE
=CMJA
-----END PGP SIGNATURE-----

--KuLpqunXa7jZSBt+--
