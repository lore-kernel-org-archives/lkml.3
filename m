Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbbAZQDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:03:51 -0500
Received: from sauhun.de ([89.238.76.85]:56486 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbbAZQDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:03:48 -0500
Date: Mon, 26 Jan 2015 17:03:39 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: tegra: Maintain CPU endianness
Message-ID: <20150126160339.GD13494@katana>
References: <1421756555-20266-1-git-send-email-digetx@gmail.com>
 <20150122074001.GB427@ulmo>
 <CAAVeFuJHST9VOWXe_cZNvLmfGdamuU4HSgdZC6EoQvrsGFt+Fg@mail.gmail.com>
 <54C115D1.10206@gmail.com>
 <54C12010.8040504@gmail.com>
 <54C130EA.2050505@gmail.com>
 <20150123094552.GD3835@ulmo>
 <54C24C2B.1070907@gmail.com>
 <54C2601A.7000005@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <54C2601A.7000005@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Gaahh! I'm sure it wasn't working before! I'll make more testing and send v3
> without "val = 0", if all will be fine.

Please either send V3 or explicitly say V2 is OK. No need to hurry, just
saying that I am waiting for updates here...


--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxmVbAAoJEBQN5MwUoCm2rLQP/0WMl+aUZlYeez5AuGegWpdJ
kaedZGnPVxHNj3haQE+YMC1G6FL6qnB1EnRRKsEwUuM/jFHTtWCKCfcYevpBzqal
7yOvGJt+5vGhcwnWB6epsCQvjQy58JeACkj7f6oLlYDj1fxJxxUYpcX4vttYlTc+
tboAM4WlU/QhiNNfvyNmCa1AGplBqNobbDpgHs2fpXP9o0GtjGHbfxRuCgqUHQ0G
oTeCHwzcPwwUonRAXBXkLG9qrxuwRaMpfO9VxXYOaiFfkh35E327X+r4rYTdtwpf
phcd4elOteJf8KFK2iVFegR79KYoky01Fq1ytMHyUALvufpsYZqBynv2GCzSYAfR
jTbM1zzrtAI2a5vreESugtvSYdFiVfYfWjmJqg/f3VirskU/vbuIww8mMproHSsC
3CU8aZGNhv9XD/kBLvStrtzmzh/po4HI+Do+z6Z9NiO56hfsiyvPWZHEIRNfcYbp
vWWKTuEdbVU50vkyIWEt0NyFl8WaCxaCa/YfzSrfEexqsI6JYaXmmLzF1KmN3Ga6
eO5KY7qVdbR13+TJLx9QhL3Q9GadQrTllkSvHiA7YD6b1HAfWRt4jpfePEXE23G5
bSR5K++VKWl/YnVCS/k4i0XfSiEUAn4cfb7hM8TAq391K7g7j1FgTSDtkzKnICiG
zgzJplhuujK2yBu7mcCf
=9K6z
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
