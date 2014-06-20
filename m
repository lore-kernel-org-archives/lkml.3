Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263AbaFTD7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 23:59:21 -0400
Received: from ozlabs.org ([103.22.144.67]:48781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480AbaFTD7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 23:59:20 -0400
Date: Fri, 20 Jun 2014 13:59:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Paul Moore <paul@paul-moore.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
Message-ID: <20140620135912.48ee1dff@canb.auug.org.au>
In-Reply-To: <20140620034356.GB20601@mail.hallyn.com>
References: <20140618084046.1bce12cc@canb.auug.org.au>
	<1446656.4HCLD295vV@sifl>
	<20140620010837.692e5472@canb.auug.org.au>
	<3494783.s5KPIUO972@sifl>
	<20140620085931.6427678d@canb.auug.org.au>
	<20140620034356.GB20601@mail.hallyn.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/v7GFN_S9u6LCFG4FFv827D4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/v7GFN_S9u6LCFG4FFv827D4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Serge,

On Fri, 20 Jun 2014 05:43:56 +0200 "Serge E. Hallyn" <serge@hallyn.com> wro=
te:
>
> The duplicates were the result of several misunderstandings and general
> naivity all on my part.  I'm actually still not clear on what usually
> happens with the selinux tree - it feeds into linux-next, then gets
> 'pull'ed by James into security-next for a pull request?  Do you usually
> send a request to James when ready, he pulls, then he sends pull request
> to Linus?  (Or am I wrong, and you usually send your own requests to
> Linus?)

If "you" is Paul, then I am pretty sure he asks James to pull and then
James in turn asks Linus to pull.

If "you" is me, then no :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/v7GFN_S9u6LCFG4FFv827D4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTo7GVAAoJEMDTa8Ir7ZwVEc0P/AzS0UmvVo+hOfZYWflQH5Kc
VuSQ/OC5oRInuMBdbYEIv/lrh/6lenBmmVlZzCOWVw2SoAL0sq0Ish+tCU7zYuEW
xFTJ8mdJAtvsFlCfT3OOkrefB/FSvugTUc2YpY2atl+RAoBMPZrhccXa4MguvO0o
DyZ7R1bsMcZ6qW5/ZJ/9/ZAnlfOb+44YacCwPL4JZTkBfMc0Zr5G6Sw9C4wIeJsE
Zo+L9zmad7RGuiJyp2YwN+yp9IDpKkwA7GjkA5lYbGUq9K+uQsdYio9lb16KFXLO
PRJ6hSNZhTcLUd6riZMJ0dtrUr5geuIkGPmmzBKPiheu7PQ4mT1FJrePiMvZRpjM
2pygzxvkX7Gns+Aa16SsVQSpN6wXIZv0Ti0E5gfU9G3mmbKe6DhYUKgSRcBWZsvf
owvyI5LJ84bFCw86JPZGPRkq5PnXoGRtL0Jyq6wQ05HQeaHQxANuITHzGHdx/Wfn
V2ov8ua96RdzujVCQiZzm5cIdKfZLGdWng56mKnn5UAMdDMyhNYwytjPPvZD7cul
m7WlV5XTIEbcPSlNQL+pMj48TYuJP9MMrBdXjQAsoOQBIlOmHcNJ4BqRkNuC2T9F
1MdEdBEC5I0fRHIs0QJCnOdNKngencMiFbrtiwmlK2Xen/TkeSTAYEybsrqi3QSk
TSakyIrEeUtG1oRu/adH
=7Cae
-----END PGP SIGNATURE-----

--Sig_/v7GFN_S9u6LCFG4FFv827D4--
