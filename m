Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3CKTtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:49:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:20174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKTtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:49:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,825,1355126400"; 
   d="asc'?scan'208";a="300235125"
Message-ID: <513E355C.4000204@gmail.com>
Date: Mon, 11 Mar 2013 12:49:48 -0700
From: Jeff Kirsher <tarbal@gmail.com>
Reply-To: jeffrey.t.kirsher@intel.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: e1000e + suspend, 3.9-rc2
References: <20130311191936.GD5000@pd.tnic>
In-Reply-To: <20130311191936.GD5000@pd.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig640270FD7F362B88D0F492B9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig640270FD7F362B88D0F492B9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/11/2013 12:19 PM, Borislav Petkov wrote:
> Hi,
>
> When I try to suspend with 3.9-rc2, it fails to do so and returns back
> to the prompt. Below's what's in dmesg.
>
> Jeff, am I assuming correctly that the fixes I was testing last week
> haven't trickled upstream yet?
>
> If so, then it's a no biggie, I'll wait. This mail is then just FYI.
>
> Thanks.
No, the patches have not made it into Linus's tree yet.  They are in
David Miller's net tree, and he just sent a pull request to Linus this
morning.  So expect them to be in 3.9-rc3.


--------------enig640270FD7F362B88D0F492B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRPjVcAAoJEOVv75VaS+3OeK0QAIKjZFNhL58LGx1Cmopu3zJ3
IKfZ2lrGsORLVKzvrTKHaV2gmGAJZug3yMr2JWideHjCbG1a/xi8P5kIA5oHrTrb
GjBU3dymlpycpRig0flwM7Q7rKfSYNDLspclJFmPYqAtkrJBVi1AD/opoF3s2Bj/
an6Srz0KPvjV7gg2PkVZg3erRZNjwhelYvMqIqiScnIbTvupGuBS547LPlkShIte
l6pGWfvke/M2wkSE2G9As7346AC1z6DVJEmG5DFj4OTPQZLvBb+B4ZxM0AphGuX6
IK5qIj6Jkng12M2PJNMDE3hXPHLNphce+e7ooQLfK7UQI76b6WlZUlyY6zgQOcVd
UcAJv1ze0acMBmxTtRGwkCU6MZfeq+zNgLd5pK3eMO4SSyHOBzj5HgWQQHCs6HBO
RrvCVvZ70yWBJYkZHHhip4LWjNRcBW9v+Fu+hkv9s2BV6g0AIJ+iAxIQHvw6koiL
uDaV6lpsNamUsFc/AVk/+QVfk0OjwwYH9+yLbntgTP+q3PIY+Z3CQ5qcOhmGFQ17
g7w40cyOH9nvlPRQSqG/YpAxJ0jWoQhWd0uBSjase/eigQ28rajNvwUn1imTSaAT
pi0P4iHT+munISzUToSrTEolcuIys/QqGsor9EoA8AWJ4ITg49wmhmhQ+MyEoVu8
iKggK9PL4toMh4FmRaqp
=9uCM
-----END PGP SIGNATURE-----

--------------enig640270FD7F362B88D0F492B9--
