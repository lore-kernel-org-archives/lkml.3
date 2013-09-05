Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab3IEXGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 19:06:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36263 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708Ab3IEXF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 19:05:57 -0400
Date: Fri, 6 Sep 2013 09:05:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: problem fetching the watchdog tree
Message-Id: <20130906090550.1b995b91877609b9361f99ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Sep_2013_09_05_50_+1000_9S53j=lu+xmyD5sG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Sep_2013_09_05_50_+1000_9S53j=lu+xmyD5sG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Fetching the wireless tree yesterday and today produced this error:

fatal: unable to connect to www.linux-watchdog.org:
www.linux-watchdog.org[0: 83.149.101.17]: errno=3DConnection refused

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Sep_2013_09_05_50_+1000_9S53j=lu+xmyD5sG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKQ5SAAoJEECxmPOUX5FE8lQP/0J9XA1ayMzI3JJlqCYVMNnu
1TgBLcGCqipt5Nmbr5Ukr+XsH9bfWUiScV7OZSCg0WCuIG7rEU5kD3RP1OiApDcV
XtV24Xb+FpwZOLxPCQoDJOjQnEtIG+y1n5FwkSw5kb6G7grCAoW+ir8MnsgNDqFW
PrmeM38wcd8sQ1WLM7b5612D/Y6ffJndIvqtbNq202/QUTNf4qfwdIZUNRSA6viw
0r/gg9E5POduYxARB8CiNdOHiWlTCrAwz+I45dlIAlBM+W6inaVVO0Rdl5hq510I
J5alh4ViOBuYAn21Gs88/Kg8o536HlT1/zmo9CAAHesUEnVwE1lf399w/0w118N0
LFqGspKEsdIUOuYgCRIiSt3jj/FNxvxwEcD684XNfKnr7DMKS1g+urtLy77eZ2vM
u39uo/CeOnAVxOOvZD/cA8kQ9eZRdOyihWum/6KODQdTlUgBjUSfjKcW74/qlUuE
s9oiyygE+gEES6+UXyjj6DbAF16LHQUQRm/gf+P7tby7BVst9YU5A/4p4aRz6QUj
I3CXAgLOcPPC6P+MbX+K/ufNk+/bmTUBNyl1WiE9JpkAsP0OLJHxJ46qQ7c6jw8r
ifgSQ4M1b1XJ3+zElgEKUxZ3hHvSEpiEffVQsqa1RHpmiXrgdarRilE4i1UoQhOp
BLFzcNzQ/TEe5myVrkGB
=Tuer
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Sep_2013_09_05_50_+1000_9S53j=lu+xmyD5sG--
