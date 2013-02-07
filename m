Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab3BGSGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:06:19 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:43179 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3BGSGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:06:18 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: anish kumar <anish198519851985@gmail.com>
Cc: Jimmy Pan <dspjmt@gmail.com>, Shraddha Kamat <sh2008ka@gmail.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: pr_info not printing message in /var/log/messages
In-Reply-To: Your message of "Thu, 07 Feb 2013 23:20:27 +0530."
             <1360259427.582.64.camel@anish-Inspiron-N5050>
From: Valdis.Kletnieks@vt.edu
References: <1360076314.14468.11.camel@oc5268484881.ibm.com> <15077.1360084416@turing-police.cc.vt.edu> <CAGTyHCoPq5K0DDwr7XWjMeJwrCw9S7kbC9Qk5saKr=zdQYqNuA@mail.gmail.com> <28612.1360099087@turing-police.cc.vt.edu>
            <1360259427.582.64.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1360260204_2143P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Feb 2013 13:03:24 -0500
Message-ID: <13917.1360260204@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.5113EC80.019F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1360260204_2143P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Feb 2013 23:20:27 +0530, anish kumar said:

> Other insteresting standard logs managed by syslog
> are /var/log/auth.log, /var/log/mail.log.

Other interesting *common* logs, as shipped pre-configured by some distros.

They are hardly a "standard" (unless the definitions of these
managed to sneak into Posix or the LSB or similar while I wasn't
looking).

--==_Exmh_1360260204_2143P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBURPsawdmEQWDXROgAQLhWQ/+KIK8tz2GQeT8h5dvCyJU0rOxF8qEo1Yq
lYqerrGSakjOyDPI4K9xhn/haeEFvz1PiF7mgH1zveP6QCbXuJjvDr0J+kp1hIsg
oUBPcshcjRK3qBCq4L9mR0UwyqhAnRgQVBcpbNfL+Xv9Ow9VFB7MXgptZQmVgVoq
PQbborhb1uApPCEx+OuLWeAbknIZkn5/VQu+mTChDsFRVbd1J/+MZicZHzWdY2YJ
NrfxYVujY8XNqPCXtz9hTYzwLID1/JL2UwxlfBzWP3KV4cx9PNZmmTPkPR7u+nec
5D08JZ/IhxyY8qbrIAui52eTazQTcHiIvd0/uzsXF2+rt4ZrAF7nOVkOmMks22Kh
IbzYgf0L0LC5PnXR4UCbh7uX7L3SXTJizd0yJ/UMEL8Vy/v71qiRTztiHdWdRZLS
Tsdijmqwh6+TJ+az/3mqzwEJoHkx3Yo+UVYmduabSdGL//og73xrca4MeQklCI7p
GzCgIAXSOCUla1X62KvKpNie69C9QolGd85CwCJzy8FX3PUDhmZxRxO1rg0LZJUz
Y9FGzEm5rJkghAntrjh3A6OjR8Yytg/gdkCX/VFkpk+tO8/bX/WL3HA54wHjGQ8f
u1bC8rKy/yUHwqWSA3EabH232ayXEprHNdAJwTjThFQRHxPltm76gPhrqQ7E8Kb6
IwPTpghwxgE=
=4SJR
-----END PGP SIGNATURE-----

--==_Exmh_1360260204_2143P--

