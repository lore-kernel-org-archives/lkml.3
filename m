Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3GHTOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:14:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37930 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:14:52 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Mike Pagano <mpagano@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Modification of the diffconfig script to support python 3.x and 2.7
In-Reply-To: Your message of "Thu, 04 Jul 2013 20:19:03 -0400."
             <10816010.V3ekNYfWHj@comanche>
From: Valdis.Kletnieks@vt.edu
References: <10816010.V3ekNYfWHj@comanche>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1373310883_2229P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Jul 2013 15:14:43 -0400
Message-ID: <15619.1373310883@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1373310883_2229P
Content-Type: text/plain; charset=us-ascii

On Thu, 04 Jul 2013 20:19:03 -0400, Mike Pagano said:

I'm not a snake-language person, but...

> Modification of the diffconfig script to support both python 2.7 and 3.2.
> Added a small change to gracefully exit if the default config files are not
> present. (.config and .config.old)
>
> Diffconfig is a utility script for comparing kernel configuration files.
>
> Signed-off-by: Mike Pagano <mpagano@gentoo.org>
> ---
>  scripts/diffconfig | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
>
> diff --git a/scripts/diffconfig b/scripts/diffconfig
> index b91f3e3..45a4ba4 100755
> --- a/scripts/diffconfig
> +++ b/scripts/diffconfig
> @@ -10,7 +10,7 @@
>  import sys, os
>
>  def usage():
> -    print """Usage: diffconfig [-h] [-m] [<config1> <config2>]
> +    print ("""Usage: diffconfig [-h] [-m] [<config1> <config2>]

Is this hunk missing a ) at the end of the line?

--==_Exmh_1373310883_2229P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUdsPogdmEQWDXROgAQKESA//X706/+hwPyjRtoOVsyA152sOwm2dKULK
6mxZkGLcEQRzsUnlTtvbAA7fPnoHjabnaW0XGte8WBjqXhYQf6POjn8zpD7L+cpa
fYUEXE4TKGQ5Tgus/MBnAmjfwgRdEt5lg7aQlCkRjiYmMisCzHErVL2XkbP0Azep
oBtzawtggi5aearsPLfZ52OQiiFL8DcMn5eGH2VccfhJs7c5gLoDC411/JNA00bI
qLq6JyFzrRKh5QvSQNHmS63aQeVSxZ53uHeicakT50z5KhyfmNEzkP4I9oo7yWEg
1Lwg+Q1EF1/kze7sDFkC+cMEpO6RPDUqcSt2wOQsHh9UEkAXDaWGckQkZ2kV6W8A
8ZWTkHdrw4JeR3zkxwxY1ndkNXcARC/uUxzjtcGuIqWVEL2vN80idnCZ2xvultrM
ON4cW9FrfrjRoxbdw7SjwnjTBJFWpuLN9cdEUD+ar+JLOYsjD6fvBCCfww64xKMp
H8MzMEki0SWBdGAnkVyEOeVRMPn7oNQNT2SscozKMP130uZMNkt/YWgb1q7HHuEV
S8z+2pF01RyTrenWc2wuNDPPLv8sCawugrxz+SuPA3fyKW+zE6eSlwvsb/aQmrWf
VVVQ75am/HNGspnzXybM8rnUm0fzAWxMnIJcflpVdlfEUDDvZLi6XjbZr9p5nmgi
GqvKkYn6afE=
=wiKh
-----END PGP SIGNATURE-----

--==_Exmh_1373310883_2229P--
