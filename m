Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbbARBvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:51:06 -0500
Received: from darkboxed.org ([82.199.155.50]:44901 "EHLO dash.darkboxed.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751225AbbARBvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:51:04 -0500
X-Greylist: delayed 2514 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2015 20:51:03 EST
Date: Sun, 18 Jan 2015 02:08:53 +0100 (CET)
Message-Id: <20150118.020853.431804627633243635.dxld@darkboxed.org>
To: richard@nod.at
Cc: hch@infradead.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hostfs: Use noop_fsync for directories
From: Daniel =?iso-8859-1?Q?Gr=F6ber?= <dxld@darkboxed.org>
In-Reply-To: <54B62C49.7030309@nod.at>
References: <54B59B9E.4000806@nod.at>
	<20150114083951.GA29714@infradead.org>
	<54B62C49.7030309@nod.at>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Multipart/Signed; protocol="application/pgp-signature";
 micalg=pgp-sha1;
 boundary="--Security_Multipart(Sun_Jan_18_02_08_53_2015_201)--"
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Security_Multipart(Sun_Jan_18_02_08_53_2015_201)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] hostfs: Use noop_fsync for directories
Date: Wed, 14 Jan 2015 09:43:53 +0100

> Daniel, are you interested in a small kernel project?

Sure, I'm just pretty busy with university right now, I'll probably
pick this back up after exams are finished in a month or so.

--Daniel

----Security_Multipart(Sun_Jan_18_02_08_53_2015_201)--
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJUuwelAAoJENOUga4eeaz3F9wP+QEe27kQ8i4saXF0dfSFXwjw
E8Mdfcjjc6ZqmFLQ715OXX29cC8xxvCWY2+gXzS/XpBhdVnJmosc72JdUsULjULj
jyb222dT+gpOXDUYevX61Dz7De+9wfUCyjt3K2KMYkI7X2RyH7Y+w94YzSKsHy5R
sOJWb0s83Ir2ecdkN+WElZ1aD1F3EN+65QVldP5O4+eWpTwhuZdXgZkmB76VrEm1
VidK4Uy0IQSbdnX3b3woe93zV5ZLLvzJWt468lU07bwHxrL/6mpqeP80v/cYSjNL
BD5rNcKH0LgsCXR+gMlYzTeqNKLfnZYWjQ5GcSTlo2jqrbg7LsftaiqYNeZJiNrs
sBykyo/1l2RIX0qv660HXxBszSAxk27KqZFAbawn4a90HqQhuu1t6GHYE3R2g/+B
pALhAUW5gQ43rJBRHAU7uIOCEC82Wb0VRWNBJ8khirND7slbf81qxZRrfoh+99Va
qiNDnlaXsaS5vizBNbKVnUEybu443fcF2v+Hv32FZMpFlOUrZnw2hpVae+w0po4q
9v0c3mo6YqDfgN82OtpcXTP+LLI+FYP1lolWdUcbE1qR5kf3TqNnLKMrQOwletlm
wR9PqgmC2AWVg59Ysy3kIK6fgDzQxdyUiKeMkTBIMkLYzKZaOC6NFEN2N5oh+mmE
0idEZFLEH4AeFZd97wv2
=BVue
-----END PGP SIGNATURE-----

----Security_Multipart(Sun_Jan_18_02_08_53_2015_201)----
