Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbbAFLMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:12:07 -0500
Received: from ozlabs.org ([103.22.144.67]:41156 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbbAFLMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:12:05 -0500
Date: Tue, 6 Jan 2015 22:11:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: error fetching the microblaze tree
Message-ID: <20150106221156.060946b3@canb.auug.org.au>
In-Reply-To: <54AB8555.3090206@monstr.eu>
References: <20150106100346.6dbab82c@canb.auug.org.au>
	<54AB8555.3090206@monstr.eu>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Sm_EJ8GfUlp0c7s7Un=vl1J"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Sm_EJ8GfUlp0c7s7Un=vl1J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Tue, 06 Jan 2015 07:48:53 +0100 Michal Simek <monstr@monstr.eu> wrote:
>
> sorry for trouble. Server has been moved to 92.62.235.6.
> I have changed DNS record but it takes some time to update
> it that's why you can't reach it. :-( It will be fixed soon
> I believe.

No worries, I was just letting you know in case there was something you
were not aware of.  I have just done a fetch and it worked fine, so
things will be back to normal in tomorrows release.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Sm_EJ8GfUlp0c7s7Un=vl1J
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUq8MDAAoJEMDTa8Ir7ZwVl6AP/2iAi+EjcuGfR9yhUxX6jsvH
YQUTloQivNw/0KLX72g5KnrOr9+PHrdxx4jLoR+a+BO/76O1DnEqvJzCMA5tp+IZ
g5nkbCgQSLe9wt5F6Uf2WF/OnuJgGt0Yn5FJxTsNNUcdlhQDxvDLcXXh/Uu7AsNM
y/UgxlgnUjbd1mwN8Kk5ElKpDzt4D4TZiLD8OvjCDL7PlXA9FkeETkzceRo+Xsl0
r5M7zHtidWXXa77C3Mh5cxNa9obDVqYLq6v4/d7vqj9qRjmwfMCbpyRX9/fGMQsC
Zbg3W5+ADieAGVmdjBIXLsYpjJFja00OWfi2f+pj2dUwI45o6Lh6SlBfYXXP2wZV
4jYFWoOivKPfWxktGT+wmEzFEyeWB9qtODT5kQzJeMqhwlr5pRvLVPsUofvQs76w
EL1o9+/lnoaRXYacIOxOm358kJhhjYOBJwFOJEcbZKuz9Fud1FCH6ubGWq35HjPw
p0phZB7C/ouTE17RqfiT+i7NcfkxPcUCjCagyM4L4bgl9Z0MnReNmRf5pfRYJpDN
0UjplGDVMZh6pltU7oekInvAD4DGZfAg1hlRYbuDHhcz3zX1upPqlcfdZ7QF6WRj
KcsY5eOlJlM8hXMMdY4AP6pzBJpyzootBFcs7eAKCuw/1XfOf/NLGyFDsiG2TZmi
9K+hzTPOH0l6z44G0JUA
=qNjP
-----END PGP SIGNATURE-----

--Sig_/Sm_EJ8GfUlp0c7s7Un=vl1J--
