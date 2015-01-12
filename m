Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbbALKHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:07:42 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35388 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbbALKHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:07:40 -0500
Date: Mon, 12 Jan 2015 11:07:37 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 14/16] pci/host: tegra: convert to use generic config
 accesses
Message-ID: <20150112100736.GC27700@ulmo>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
 <1420857290-8373-15-git-send-email-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <1420857290-8373-15-git-send-email-robh@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 09, 2015 at 08:34:48PM -0600, Rob Herring wrote:
> Convert the tegra host PCI driver to use the generic config access

Nit: s/tegra/Tegra/

Other than than looks like great cleanup:

Tested-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUs5zoAAoJEN0jrNd/PrOhr/EP/RfVHHkmufGskRLDlXyvRQlE
ni4KIF1JuZdSg+9ZvHXmT+bEFZAiheAtamIR31jMHMADXmI/R8Jupr0sCjzYzCVa
1CNJ9NfeGrCpskbyaXl8YoJmKUJD5X+A6PhLZ65yIZzIAhiwaIrFTBpH3kuk6Mma
ecfxEy37EXFyPhB0qL89I36zePn/tqAFH4b33DtCNF+DWcSRm+SmWeY7/5FU62Dn
kEHbhmT7RuXtC1U9Ie77gFUUr0Bc5C+iU1b5yLqYccDn6yvjo4dDM0sXxcxmLxHK
TE0FJCxvsr1aDn8E6ZGN1VR2Y4lXfC5jyZaUNSlx73y9P2scGt69PHBOgFn7z6S6
FmNlhDSHRGT/FpELFaM5ki8atvShCIwUmMstcu4OKPHQJbUaIz6VDDNNYnzvUX+9
riXQTQdxTrZwltat1fjpQAxQ4MzbSXlLWuzabw7iKLDy21LnSdFiXC7I7hvwfcjV
abrtZcdgJOF9afydq/OrV3cV18ad+ZgGkZg8Iedo/GZNKj24zMbK8B9H5kQxGxWc
cYC4WB4Ehrh7Su2xMpe7naJp46+K3miOZIqy15RgX/d9yAKnmWVn2lIBHuxoS43l
6HMX6aXm/kiwp072Bpwc6NTBlRQEuNxACNVpU21QcndPkfnUAWtWZ7LBPu0uGkXh
3OqPPOL0AT4MI6bQSbdq
=ivJr
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
