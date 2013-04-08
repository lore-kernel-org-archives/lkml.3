Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935130Ab3DHLfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:35:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935019Ab3DHLfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:35:07 -0400
Date: Mon, 8 Apr 2013 13:34:58 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, rob@landley.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v1] pwm: add sysfs interface
Message-ID: <20130408113457.GA17028@avionic-0098.mockup.avionic-design.de>
References: <1364997536-9246-1-git-send-email-larsi@wh2.tu-dresden.de>
 <20130408081745.GA21392@avionic-0098.mockup.avionic-design.de>
 <201304081315.37794.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <201304081315.37794.poeschel@lemonage.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:V4KZWDNn+gYYzd7qV6gqtmLPxazS/b1zl3Bb3UAA+rW
 qQutHkyO2TtRquXmNh7x/DbqwPlmgjuS6txDLz+6DoLdqHTArK
 c40no+waeX17KfeM2mmUWaqd80yZpebdAWOf/+qZQ9tEWxJjeT
 gijX3L3pc21v2HCAM9L/OsbW8cp7PZsHHXXp+Em9UEqqt//hxe
 3VBGzTZyMxHRQuJtNK7vBwTk71Jvd3kHJ6QwvaiWDTD70UODj2
 f0C6M0f8QD+EVeKcpaWjEYlvz5VJ9teMv8tzSMXJb6dl/4Isik
 av+jwRpEEElssZYQX9yxIt66hPPNClE03kuiymFxPw9pOkZ6b/
 sUrPjBveXbJOSsfIOXgQjFYxiSsBKRY/z/B4bd0vBDtef2Hhsv
 zoB0F4EALNb34jlxTGVBPLoHcYjqff85a8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 08, 2013 at 01:15:37PM +0200, Lars Poeschel wrote:
[...]
> You mean change only while a PWM is disabled ?Ok, as said above, I need t=
o be=20
> able to change at least the duty cycle while the PWM is running without=
=20
> having gaps. But prohibiting changes of the period could be done with=20
> returning -EBUSY.

Okay, that sounds acceptable. duty-cycle should be the only value that
can be changed while a PWM is enabled. Obviously it should still return
-EINVAL if the duty-cycle is larger than the period, but the PWM core
will take care of that automatically.

By the way, would you mind elaborating a bit on the various use-cases
that you have? I'm interested in what people use the PWM subsystem for
and you seem to be the only one currently using it from userspace. I'm
hoping I can get a better understanding of what the PWM subsystem nedes
to provide if I know what people use it for.

Thierry

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRYqthAAoJEN0jrNd/PrOh6qYP/j/KcEFM+2OhVDSvusvxUOnZ
JX6bdB9DPS3HSvsflGzAV7x4IndlCuUTVP+1xWjrR5juIH2AquD+qMNpOTnqBHJk
tHWqI58KsgTH0EEu5apPK1cAvn73WQAHikYJ0bCkdmeBAICY+hNdm0OnlYUM4eER
fxg6vOTZT5ecFuYXF7Pl7nnrBncNs41PXjG1MKy5hwGj9k+Tiq4Wm8iGzsckBmif
xxWAOlcKh/kAp931TelbS+3+nFJ9P6OV4hQiD486OvtxDg7IY2qbUPlc+2K3gVvi
XGsZlx5wBSzu/LlouOduokt8E7QrNGRHxZYbdBE26AOtLaczvIJrbzvSQ+RKCpJE
Y6/688zgJHAtIyHfTbzXEcmm92FMQ8keKRkHLdRU+xOkpUt73cY0ut7eL7moYDvB
3wDR7NiIbS0N0I/LF4rKvdj720r7q220RArZQ8O7S6+tzzV9vleH9ApVqcZtkm7X
0cIYKkEVCxokkc7vBQaAMx+AMbLGnz0AlqgoBWP7GMitCeclYOsjkvgqRMST+MET
DWBcsiCjqpp1I0tiUJC8p+a2qf9GniRa5aOvx/+rp0Juv/Qa1jzYVUISrxva0pie
DXpcJeSmByjrN3GbEwUuPyvNkWFcqHeRjqxhUZD350xJB/NX0Lav+D12lLO6sgAB
YeeARWEjyMDbQeK0ex6U
=wCDH
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
