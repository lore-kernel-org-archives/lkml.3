Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3GCGCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 02:02:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40003 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3GCGCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 02:02:50 -0400
Date: Wed, 3 Jul 2013 16:02:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: monstr@monstr.eu
Cc: Michal Simek <michal.simek@xilinx.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the xilinx tree
Message-Id: <20130703160247.bc20792d7bfaef893ee72137@canb.auug.org.au>
In-Reply-To: <51D3BC5C.1080505@monstr.eu>
References: <20130703111030.c0df2a231fc3e4ba6cb566cd@canb.auug.org.au>
	<51D3BC5C.1080505@monstr.eu>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_16_02_47_+1000_izrMlHwUF6z193NS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_16_02_47_+1000_izrMlHwUF6z193NS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Wed, 03 Jul 2013 07:53:32 +0200 Michal Simek <monstr@monstr.eu> wrote:
>
> I have fixed it - it should be fixed there soon.

Thanks.

> But I am thinking about removing this tree from linux-next
> because we are pushing arm changes through arm-soc tree
> and they require to have specific feature branches.

Just let me know when you decide.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Jul_2013_16_02_47_+1000_izrMlHwUF6z193NS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR076HAAoJEECxmPOUX5FEUScQAKofcOkmXIiInGIWpl7zVTKX
nEZVELCEPloH5LyDAwpuGByi1t0x95mkX2FwtLongcQ0HeHNX6td6cLpfUblPTmx
orNinPClozzv9k8mbpabwJtGhxcMSZkpp8ty4yzBIrQB9aLdHDvNCCpEtbo7H1Jn
FTWyTBHDor4fL25UL291tk9Y8HW5EBMtfUYfe+KhSJq5rr7UlaZbFiZtQQJqj9mq
2EHvV8OweVcvTxbguFmLXXI1g8ymusPj9FdjdNUNxZD10bzN0d3rI6XscNFNnSvN
y84hyF5Xg+lNV/KC+6BOQxEGo2oqXTsFwfEle27+rncbE7bFXAQiUSYfeTJ2RhFV
RMYtSzPh0QM5M59E7hflpw6Dlo/xcEnK6uozVwXt06qn2lSF4OVf2QA9IgJhmRUA
TqAh1Q/D6sreqmJ4EiAwLlA+Rl7eZZVomAknWnznwZUJBRZOL3pkjUG4Hmgbo5f9
hJNkKTywLFRKiOqffdWhQtuizvJuUj25Ip7z3QRpfEOauXFnyr5CBMAG2XBMCct4
BTRt2TfHcJXCQg2xULEoYjNOf324uuGPfLOBWJ6rzgUl/8buU6HzrUyROpqnAwEY
1Ngbg73FCorTdDZPp1sgGZzQ6JINopTEQDdteWi17MQaRN9FFUOjUyI/ZJxUDq7K
No8hEDQi63qC4+IF5ZVx
=qBde
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_16_02_47_+1000_izrMlHwUF6z193NS--
