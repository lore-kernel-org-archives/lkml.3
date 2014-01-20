Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaATQGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:06:54 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:42383 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaATQGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:06:52 -0500
Message-ID: <52DD4991.4050308@gmail.com>
Date: Mon, 20 Jan 2014 10:06:41 -0600
From: Souvik Banerjee <souvik1997@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.
References: <52DD492F.1060208@gmail.com>
In-Reply-To: <52DD492F.1060208@gmail.com>
X-Enigmail-Version: 1.6
X-Forwarded-Message-Id: <52DD492F.1060208@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jwPMTvn0P1KU4ASqaxehfTfXGbM8nhPwE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jwPMTvn0P1KU4ASqaxehfTfXGbM8nhPwE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Forgot to cc the LKML.


-------- Original Message --------
Subject: Re: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.
Date: Mon, 20 Jan 2014 10:05:03 -0600
From: Souvik Banerjee <souvik1997@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>

No, I don't think so. My testing shows that it is now just reported by
the keyboard controller. My commit is similar to
'f1566f0dc07ec9b5409b348070f5a700032d7881' in which keys for the Dell
XPS L502X are added to the legacy keymap to reduce the noise. Without
this patch dell-wmi reports an unknown key, but with it those messages
are silenced.

--
Souvik Banerjee


On 01/20/2014 09:31 AM, Matthew Garrett wrote:
> On Mon, Jan 20, 2014 at 09:28:22AM -0600, Souvik Banerjee wrote:
>> This key is reported by the keyboard controller but also generates WMI=

>> events. By adding it to the legacy keymap the WMI messages can be
>> silenced.
>=20
> Wouldn't this result in it being reported twice?
>=20






--jwPMTvn0P1KU4ASqaxehfTfXGbM8nhPwE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS3UmaAAoJEDYrZuXu8ZIMWi4QAIdcOLyzBDQB5/ZAjdjahfxl
Yqan+PIatBESjWy0vwH+Hs/1HKm2VOfTVqGBR0oahKpz4Ir+o9OvU5bUiMFy3NyR
/wbJuXjkDAlcXo8dhEwnn9Tjr+zMYsylAT/xtfIxs7TX4uCeg2NNs4yPGrhJVnUz
90lAxyaWCEjDi9kuna8BM6uSjXMlNb0Rx3CTqseKMuPpx9eo5y+kpzdxs0mV6Wpy
cw3gwf0/0aVY0o81G29Mxd/qwozyGgHPjGRLtZgDrChOMDqzZAvMM5szRbxW0utT
GgY36A3ySZ+rB3N6PufuZlQmfRXBqCKjpurAh4oPzqCYEiec/oS72ayKsGWKFfXp
jXPqUrDWkvv8IMfAW7upg75A+gn3gLrXqefsAeXFswf9GK672WOd7nLhuHby+ryS
mmZ+edGM/Vn+kcopA83oATEqrX4v+KBxa+sOYnruWUgrgUDwnzxuseEaXaAwfE3f
U5hGZL8HoTaWE3/Hr77o8p8DaoJ22LHGA6q7gmnq9ms9elieI0pZGBrYXR+m5mv6
WlBilEl1u/J4ZBz5z5x9+LiDBsmvCEtXz9eimqTUYN/GO3VkjQKfcpkxgoREbliO
Uj4dGE4UIWLu7mJS36SzYB1XdHFheYHO8E4N1sP0F5Gsbb/b9HV3SE7UShCYX5MU
+BcZKLywvufPNpRAS/RL
=392h
-----END PGP SIGNATURE-----

--jwPMTvn0P1KU4ASqaxehfTfXGbM8nhPwE--
