Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3BRDfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 22:35:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60106 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3BRDfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:35:42 -0500
Date: Mon, 18 Feb 2013 14:35:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: linux-next: manual merge of the tip tree with the kbuild tree
Message-Id: <20130218143528.451b9e1e19d79693c5673414@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_14_35_28_+1100_XBTzKu0EdQw=EKMG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_14_35_28_+1100_XBTzKu0EdQw=EKMG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/timeconst.pl between commit 70730bca1331 ("kernel: Replace
timeconst.pl with a bc script") from the kbuild tree and commit
63a3f603413f ("timeconst.pl: Eliminate Perl warning") from the tip tree.

I just droppped the tip tree version (I deleted the file) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Feb_2013_14_35_28_+1100_XBTzKu0EdQw=EKMG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIaGAAAoJEECxmPOUX5FEKu0P/0XPqDX+zVic+fCFqPdlCdNd
uFlGzYy7iE4G4j+WAzxIflGYSce0rfaLLl3OUo8VdlbVa7PnRoJljW1USAiy1V/K
W2Y+LnUf0dI3GIr2u/2wNeve51l6kn5sAn84XIhRNsWGzPJ7BD4OZN2iRoSSmfmF
g5BjZb3C/ag4oWtv3+6lUV6evmiv8ZXl6gC/1LlA03BpT+L2buzhOcGg7FQhHrH7
6GVVilHUFAH69FyYLKQNM74/BRSvAW3HkEG7AphCvrtBiBGbdEGEX8PArkKpXPPG
G9bNRP+LnfFgMSQz9V1kdeNlqTYka63gp5S2LeK+ZuShpmRO6J+fvuEJAq1US9CX
8n0tgigRPs1OgBmyqVtjkCsBdfYDZ7yhA5YdUXr4WlZkMcx8K5JdjX5T4xGe/egW
o6uy7ludS5cWMkrvSBUc/Cl9N/wpjnVFRotX8Sh4Y5OPlALQNTQvf+hTMXAi4Irj
OTIAkpumAwUxQv5M9K8i5gFD3NdhjGPwcmF/tbWkfqn0E9r0sgUsok0zM5iOFZcy
lgQe6jHl/L8j1K8d4RTPWCO2iKFUQ4b+TVr3iI7rfdNteaYlU/+a57yRH80vgpqj
ysBod3uC7gk6FhyYfk+UicCuMZnA/FOmILdbwW0kE20R+O8gxMV1SCVfjYY8txTJ
mY4lOqM2TmXl1awV9uMQ
=7f0O
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_14_35_28_+1100_XBTzKu0EdQw=EKMG--
