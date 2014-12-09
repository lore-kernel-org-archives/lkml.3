Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbaLIOIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:08:46 -0500
Received: from ozlabs.org ([103.22.144.67]:59150 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906AbaLIOIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:08:45 -0500
Date: Wed, 10 Dec 2014 01:08:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Russell King <linux@arm.linux.org.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: linux-next: manual merge of the slave-dma tree with the arm
 tree
Message-ID: <20141210010837.2f83ed79@canb.auug.org.au>
In-Reply-To: <1418132328.19339.9.camel@AMDC1943>
References: <20141209140901.685bb382@canb.auug.org.au>
	<1418132328.19339.9.camel@AMDC1943>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/3mM1+ilWb4ZXb=/F+q5hPnT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3mM1+ilWb4ZXb=/F+q5hPnT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

On Tue, 09 Dec 2014 14:38:48 +0100 Krzysztof Kozlowski <k.kozlowski@samsung=
.com> wrote:
>
> Looks almost good:
> ++      pm_runtime_mark_last_busy(pl330->ddma.dev);
> ++      pm_runtime_put_autosuspend(pl330->ddma.dev);1
>                                                     ^here

Thanks for pointing that out, I have fixed it up for tomorrow.

> However I am looking current next (fetched few minutes ago and the one
> visible through gitweb) and I can see only mi changes (related to PM
> runtime). It looks like slave-dma changes got lost on the way.

Yeah, the slave-dma tree had another build problem so I used the
version of it from the previous day and so this conflict did not
actually occur today after all.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/3mM1+ilWb4ZXb=/F+q5hPnT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhwJqAAoJEMDTa8Ir7ZwVbJMP/iRLO61zlAYpc+VgLnED0C9P
vod6o7Tvplng8+9MKPh+0XygH4mByXqUVQRCvH/Nj4pwyp7bjME13wQP7DqZVCfQ
2HMeCTW53mFfm7+w8f6Rd7I7xie8saz2/4r57lG64cC0Wyxmea4ZLR078CsRMdOQ
XmqnkgfYV6u9alMEM1ie7HEx5iwuRSEPzN9j6ysSAu7xDiW5Su3MgCcWPCHfHQA5
RSe2IqnoQ6/q5oBPIBR3wuH7ZqaiCRyYFxuYrhtXOGo0EOh7g93b/VtPVy629Azy
6n7y2cj33s6SDoE3UNbCxAgzB29ail84ElZyFx22hQ2Ta0QMQQkXTYsKjk5Lur3Y
4EV9H8ISJpLNuHLjCvxdMApaPEHwQBlSRyyxmYh81vbLyQmegp2KtIoDdTqrHer/
gRQHpG+oyooP/bOws8tAkkCvsk2Pj2soFrUIzAI7IPTcR/J9StPG5cksLU4YyZIW
9o++wXSKr5L2nUAWu5UWv4XkInvWHQXfy9J67tb1AOyYyZ46brdI8v8g/xYhDyXy
T+SOZ9ia3t5ca+5TCfnaKMhMMsfZ5B4rDw0J+87pBE0FRxVp5Mpvle+npCl49Sro
6mFSIiEvkvJd87ZOqQNlruzPytSaPpLzKXj5jxap4x8Ak/dc8QN4VqwiGuU4oBYV
l2HtHWlWTH4ZfaOpFtPl
=TVcV
-----END PGP SIGNATURE-----

--Sig_/3mM1+ilWb4ZXb=/F+q5hPnT--
