Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaADLn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 06:43:56 -0500
Received: from ozlabs.org ([203.10.76.45]:52436 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbaADLnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 06:43:53 -0500
Date: Sat, 4 Jan 2014 22:43:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Simon Horman <horms@verge.net.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: linux-next: manual merge of the renesas tree with the arm-soc
 tree
Message-Id: <20140104224346.c0f1689a8c7c62d4ee22aa3b@canb.auug.org.au>
In-Reply-To: <CAOesGMgi3COtsr+-9B3Tt350gwBs0Qm0AjatjLWCWTeUkAP5og@mail.gmail.com>
References: <20131216104738.6f845aabd0e3b609ed9ca170@canb.auug.org.au>
	<52AECF56.8020508@atmel.com>
	<CAOesGMgi3COtsr+-9B3Tt350gwBs0Qm0AjatjLWCWTeUkAP5og@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__4_Jan_2014_22_43_46_+1100_/nb7zquR3m9De_uB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__4_Jan_2014_22_43_46_+1100_/nb7zquR3m9De_uB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Olof,

On Fri, 3 Jan 2014 21:11:29 -0800 Olof Johansson <olof@lixom.net> wrote:
>
> Now I can't resolve it properly and move the entries when I do the
> same merge (and get the same conflict), because that will cause a
> third conflict for Stephen, and he's about to return from vacation and
> is going to cuss at us if we cause too many new conflicts in one day.
> :)

Since I have now been made aware of the issue, you might as well just
sort it in the merge.  And I have never been known to "cuss", though
ranting is a possibility :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__4_Jan_2014_22_43_46_+1100_/nb7zquR3m9De_uB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSx/P3AAoJEMDTa8Ir7ZwVaPgP/2COOcBi8EFoW8hWNKdTg98q
dBmGNCxvvDSQyeBTE8wF2oFavLheW7hHnsLU0eOgb03L6CCctiPKG6ouuA3u6GwG
nLePLl7WlXXESnj5rbs4D3yQl48mE1HKQGSjSTuIScfB0sKcefWdp0Q9B1JV5YRi
vPlnqfUUExXlIbsHg9nowd1DiWy9y64TWIQdkmph+wQbZm2uC5BnW+OBpEQKiTh3
tmewXdPbbnr4/VvqPwos9+GUEr++1+o8CPVZ7SRs2JevVgxYQkNM2FmSyTfEILaS
06i/C3u6lYYQHUVJeqdxwF7Jtaz6iuah/3915TtdQIxgcGNIcyX+7kUwDusKwHGE
OVdbcsAQ/dzqZjkfSAnRdZWah8I0Nv8j0p6L99Rzn853snyOu7yjrmSJzSUw7yLM
+M1+N2cqIr4usHlqIi4vuld04lI0OEb3QYYozLqelgj9ZDUYpgtVdR7Jr53oPxt8
cr+ZtuYe7EXkOteWUOiIzN0hJlxU/izBI7QEmEnHBoTuy7Udn0UECQNAovD21y1E
heBNoC/wt7TxzzeBxcTZuvoXuRoVM1gboaauvsu2+pHfKVjz3RhT4p359bqtAPau
FCD6xg8XRVXobPworYpHJVNW46YvORf+3e9zxx8/k03LkVMOHldy96KK9hGYKf8p
GzXyWtmR7ZyuvPb3zSEx
=pRSB
-----END PGP SIGNATURE-----

--Signature=_Sat__4_Jan_2014_22_43_46_+1100_/nb7zquR3m9De_uB--
