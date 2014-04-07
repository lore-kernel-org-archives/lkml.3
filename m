Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaDGKsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 06:48:33 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:56068 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621AbaDGKsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 06:48:30 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2014 06:48:30 EDT
Message-ID: <1396867174.6220.4.camel@laptop.site>
Subject: proc net statistics
From: "Ken O'Brien" <ken@kenobrien.org>
To: Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 07 Apr 2014 11:39:34 +0100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-5BwiKeJBY1tFq03/K3y2"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5BwiKeJBY1tFq03/K3y2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I was under the impression that statistics reported
in /proc/{$pid}/net/dev were specific to that process, but the values
appear to be globals, i.e., identical for all processes.

Is this a bug?

Regards,

Ken

--=-5BwiKeJBY1tFq03/K3y2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTQoBmAAoJEH6r6VcNuxY8JKUQAIEH4g9ZpS1tYjvhRrZvr3hP
kjmZU2wqR9WQOYnIhRKqGq2ROV8128VJ3eN3NQCYY9dG0uMzrtrWBAMNYXQX0e9L
aO1rvsQoZqa/a3VKn+sZjqEUFlRwmUuKggvH7HPycoQ3n1wyFlk5FsnOOLwWSWAC
BJoey+ys8A9Xh+locADuxK2FaPN+XcjcwlZjNX1k+asEAgbX/yGXf207JEYS/+G3
4Mrt+r9STP/X+efdqe6kyXWDcsKrW8YqWKKMjVN1SSKkHb/vKPKCmjEN2LuY99cD
gnwjrs2dtj3wbwQdU4KAwzoVTGp5Cy1MyKwrOPRbkndJVKdBr5b8nSmu9WdXcE5c
cXNCIRRpTb/cj5tTMrnEwNMDqL3/ppViDcbN5h3zXh4LHLq1MPhLaxZh7WbbTb4q
KIcaqt5zW6A9yxo7CMEj0ABwT3mhKQt86aiv/rkUU5gXPkTlhCfUSQK0GOpDBam/
RlGTUfF4aAqt9YMkdUwJJSye/8HiRiZhy0lWCgY5Gofmfpc2/2NEaU/BIcLFWs5O
1ncpNVvAl0zwZxgO749S8rlaFCxGtbeUq6Y8CDDNPYDACK3TMaPKGz7BD4OpZhLh
OEQw/PlXqyzjzfjOjGsYSvRDsP5VbZlGtHqnlhzbQjcYEyBQWDtwscxcWCCNV/im
gF70GRlCnvo+yjgA6r9m
=Ey+0
-----END PGP SIGNATURE-----

--=-5BwiKeJBY1tFq03/K3y2--

