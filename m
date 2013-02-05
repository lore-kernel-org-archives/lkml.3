Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3BEUmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:42:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62369 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3BEUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:42:07 -0500
Date: Tue, 5 Feb 2013 21:41:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-tegra@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/14] ARM: pci: Keep pci_common_init() around after init
Message-ID: <20130205204147.GA29726@avionic-0098.mockup.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-7-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1357764194-12677-7-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:lp/k6p63ro6C6sNWS2n8iGQyDlRw/HT+G9Qcmm63Zv3
 JEiT6/jY6+azDKimN8sfHkt++WJEwdfHPGbbBwJ2bAlVYwi8Yr
 BORm1oIq5/K04OK3CpNGlrtL0DoSJTMQ90VsWexpJM0179lVUo
 oCs8eZcJKaZb3cixg4C2RPZG9d3UEKbQwNDeEOZGbsZACQUm1K
 kqF9HWCFjz/s6g365Xm63JqqhwMvG4RNlbHWjQn9AwIbcDGyVB
 YZaE6EsB4bB0hoz0dklLjpcOButulHeKejIuYJGToJxBqCYWtD
 HUudzoIcAItBRrHYF2w+oQ4Zs3uI34m/4mcHXurJn3BuOl/7gd
 FTgetsVLwswHpRM8TkHg6Z4u1NOLyuqq0Vt35sqvZcV95SmZhW
 1CaS0inFSjQkjXHy2piLCfNpg/6LebtzDRz9OAGJSYQS3aq/cS
 nDejd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 09:43:06PM +0100, Thierry Reding wrote:
> When using deferred driver probing, PCI host controller drivers may
> actually require this function after the init stage.
>=20
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  arch/arm/kernel/bios32.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Russell,

Can this patch and patch 7 (ARM: pci: Allow passing per-controller
private data) of this series be applied for 3.9? Thomas uses them in his
Marvell PCIe series as well and it would allow to reduce the complexity
of the dependencies.

Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJREW6LAAoJEN0jrNd/PrOhf/cP/AkweukDR4WeNx0QMOdyK/iW
f1Dguos5LKUkopCySMS2Qk6+DVo4hQo27XXyt3cwCouv1+AuGmbOwPUmwbb87NMu
r5pxzJymWRHz2qay7rxzPE2/ATiX2gC2TTt3ocfkRI8S/8T2X+XKgVyxpORBcXPg
MnVc1/09CENjShYTVxDYYXrMaJx0wvlrSsXZ7c6SQNQmjFj9DLo86nak22ujJz3K
HvucbWD+P47P/NVr9acNaDBBsHSBsS1mdMVfzzvijFXUcoFQroy+5lvfTxDBHlBq
dT4Sck0Xnr19azQ8GVG3snzLQg0lYmEcjjEHzxaC04G0I1hLZejm7VwMblUBSrxe
8up2hoZBCyXY6Aio7j/jsOV5wtHxk8warI+vAdpNAfboyXYFZ4Hilw9QQfZSCvrL
p7XNAuH39rEcZML6SBLO2j2xrvIU8lkxH2qNL4KnQ5AAnwOJ9vvXv23z7HN41l0k
FOR2JN8Fc49tSqfdH78srNbv4KXaIwGc/ZmcsV5hgn89nkhMvdX9dxeDLjneAIKS
F4Mnu7iYE5QlMIOb4Ex3cmACkEn2k9w1B3UWNJgaMznpNlgm6Z9szBJazcujfYDD
fDPLgsV7tfIcHxdikFH6GTV4dOMXt+z5K4Yt7R8r1iRiJpdbWTfiMr2brFGCqYWv
iLSbdQcQUFeIbqRMON0J
=+bQg
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
