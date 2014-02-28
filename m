Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaB1HHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:07:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52573 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaB1HHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:07:50 -0500
Message-ID: <5310359F.2040904@ti.com>
Date: Fri, 28 Feb 2014 09:07:11 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, <linux-fbdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] Reorder drivers/video directory
References: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com> <530F80ED.1040509@infradead.org>
In-Reply-To: <530F80ED.1040509@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iMGxIqAHjjdGhVgGQrmIv1S4kXFbNonoT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iMGxIqAHjjdGhVgGQrmIv1S4kXFbNonoT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27/02/14 20:16, Randy Dunlap wrote:
> On 02/27/2014 03:54 AM, Tomi Valkeinen wrote:
>> Hi,
>>
>> This is a re-send of the series, with RFC removed from the subject, an=
d a bunch
>> of acks added.
>>
>> I'm cc'ing more people, to make sure this doesn't come as a surprise, =
and to
>> make sure this is not a bad idea, doomed to fail horribly.
>=20
> What does this patch apply to?  I can't get it to apply cleanly to
> -rc4 or Linus's current git tree.
>=20
> I like what I see so far.

My branch was based on -rc2. Some minor fbdev fixes went in after that,
and they seem to break the apply. I think the drivers/video/Kconfig and
drivers/video/Makefile are the most problematic ones, any change there
will conflict badly.

I pushed my branch (still -rc2 based) to:

git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git
work/fb-reorder

 Tomi



--iMGxIqAHjjdGhVgGQrmIv1S4kXFbNonoT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTEDWfAAoJEPo9qoy8lh71kf0QAITLze2ZIokXZbTwH0b6CsVS
tI371KVN2dOFKnHsh4cUxFR3jIAPFW8G4vP5APdymeK2KUqhyQa+EkGBjWzl73Ty
3R6ddcudt7692KzlG2O0RD5TP6sHsVdqiGbu2mz8+rZjECZd+YACCocvxiWcEgyS
3nzDMHIDw+AKoa13yxy+7/Ht9rAFpVJfA5KYoE6UvkADts8xgmk1LdCJUu0KRCjH
B2KFNT2aIOai4ya/Y/fdc/Fal62Bzo1msccKN4Bx5qUXwU4OxI2kalKaiyiL1INa
wGkLx7WDhLAvi5m04rZrdK3CxXphltdO/OEhQNYuYRacDIRYrkNrEtofYAfS1vAy
StS9Pq8R2+GCS+RNA2VCx5Nnv44w6g7z54Y23hIwvY78jQRTc2DtBQIyo8bGvCN3
ITK7nxspQvo79HFnl0qXVUSshIAJvbqMQW7SMIu6l6VI7MU/KKCF2xfdzRtTzeBJ
he2gAfOr7Sy+0enFDbY9ikHkll23QnWHJZh+Dz8f+BuJw3Hm7UmCP47/wgbMct/f
hc9V0AIeul0RmSJAZSwR3TZgnR215H62CMjKIASEOE6ciEzH5fEXVqmyTUqFyVz+
eeAMk8ANDXua0ZOYrdYn9m93fnjylrWmaq4Qky3Qpudw405V9QioMZzEYJ792t43
9OBBBHYo4qd/r6nsteTn
=DIoc
-----END PGP SIGNATURE-----

--iMGxIqAHjjdGhVgGQrmIv1S4kXFbNonoT--
