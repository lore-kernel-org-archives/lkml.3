Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab3EMSQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 14:16:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48382 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3EMSQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 14:16:35 -0400
Date: Mon, 13 May 2013 22:16:25 +0400
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130513181625.GB14811@sirena.org.uk>
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <20130510212422.GY3200@sirena.org.uk>
 <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local>
 <20130512143344.GC3200@sirena.org.uk>
 <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local>
 <20130513052135.GD6836@sirena.org.uk>
 <0bf5a185-86f7-4a93-a90f-42caefb06a1d@TX2EHSMHS009.ehs.local>
 <519112F9.2010102@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <519112F9.2010102@gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2013 at 06:21:13PM +0200, Sebastian Hesselbarth wrote:
> On 05/13/13 18:09, S=F6ren Brinkmann wrote:

> >Well, that driver actually exists. But that just programs a bitstream
> >you give it to program. It does not know anything about the design it
> >programs and cannot make any kind of decision whether the clocks should
> >be userspace controlled or not.

> what Mark wants to point out is that you add fabric clocks to the Xilinx
> driver instead. This way, you will have user-space controllable clocks
> but only if you loaded the xilinx driver first.

Yup, that's part of it.  Though I have to say that if all we can do is
stuff a bitstream in there there is the question about how anything that
does require a real driver gets that driver instantiated...

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkS3wAAoJELSic+t+oim9N+8P/2AFK93Ocxchexm9E+w+CHZB
2b/lTNZuHcl7Bvo/ScZLociIbdgW7fGRPIHYTCwsORJ5HZy2nFjcvmgNwgvRxhzq
Ix12pvJeky6WSc7iG+gqXlCId4P7EurzjiwTnZ/qudB/6BxcxHFUF/I67D/QPG25
8R0ohF19iMv6oNTFJxXrnH2NMIAmFqU4qZ2AliKrzoZkeW6lqfK6xsUkzUTVi+pm
uu+ECT5JCh+wJnXe5eZtI6RpRZh8cM7r3gmS1OrLrvCkGZv32ITNa+nXOyrpGJj4
UGt7ckTLc9Arepx9CmKkNVaqpH1mApqo30Rkj52oo5ZAH1H2lvFniO9arwfMAK07
0YUlFRUPrawXPG+48cJR87t/kEXL9xOKXBCdEY0wJpqYVPuLDDHeaAxF0hom/1zP
wnixe5Me6W5gsXMjyaC7ZlfuDaIMPiefrSiLDk5aNCeDuhkGbvjZR8d32/MXGimh
nLugdVfSImknMGRe+cjzojobNYC2kOwucSweuVP/qsFiJozzhx+h5RVnUfzU+gFv
HfZKuNQ60E79VRE7yG17rY9tfKci3ZR6HSMBboUw9Q2XG+PLUBrzkGYpC+Z3yGKl
35AKykK7Jvqsfi/PUI4W5gGbZDbafpfaMzAVvVGogyIaMlvrPAqTMhY6lrwYWeDG
B5WhcV1i0O/xnUDRMbjh
=j8Sj
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
