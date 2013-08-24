Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3HXW37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 18:29:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48162 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863Ab3HXW36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 18:29:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] ARM: Add ".text.unlikely" and ".text.hot" to arm unwind tables
Date: Sat, 24 Aug 2013 18:29:59 -0400
User-Agent: KMail/1.13.7 (Linux/3.10.6; KDE/4.6.5; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
References: <1375825275-21962-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1375825275-21962-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1624105.oL8gKvgZBb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308241830.02079.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1624105.oL8gKvgZBb
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart1624105.oL8gKvgZBb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJSGTPpAAoJEEFjO5/oN/WBZWcP/jI8TnYSWuLMvuZ1WN1aoRGH
GcdRVa5odBSfgQX+W6+sboIBbui5jMxPY/RsNvTvnTCfdTIs2onhPAL/D4AUBwm3
NG87QYQP54HYL6KN9G+H7gsZdA0N5r+nrQWcmlGSVPj6FHOtyYtaeA8X5Q58uF89
B6OAZpQF3vXUrbKpVZPmAuQ9GbIqpEV06pjo4T8yxAylgowLhNGtQX3TUjO9+kuf
vE+fP75jz3yWageoy0dWQKQk2/cuqSaZOmh2nNmFD7XEkZF+R/WLvLd0ZcTO9qZU
9u+AOzaktrl1zt2MmL7rQiKhD4CAFZ3ASzG0tC1C2Pj4bR9vEPAWE06px73+GxML
REAwjHHupndGktFOEUb2t6R1eMIe7okOIpwJsyFTZnzqijK/ygAJQOWt4e7XDUqN
q7vpamjprvazXj3skO0vtWaHJt7uwB5ulrPyOq5VApdBQ06xUzczLlrokiaHEu9V
1h4fAXMeJeNs+7TAtc2daL3r5ZjhyVGRZPmi2Jq/3DL5bOAiC06fXMxk7oE/bqku
IlmN+o9fHI+pTVWBQtFq2mMB0oGc5Nnxse6GOrjgP5Ip6iaiABLr4cVCc6GNDhic
bAJwMtamZre9Si1Kngfh2ZY5gJnYjPsFBweE0w6YDwxjUU/FQhiYnv7S9zz4nesF
MV2Cn67pceG3xkcIdQ5X
=Lk+K
-----END PGP SIGNATURE-----

--nextPart1624105.oL8gKvgZBb--
