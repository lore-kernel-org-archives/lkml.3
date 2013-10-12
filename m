Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3JLN7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 09:59:16 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57313 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750784Ab3JLN7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 09:59:15 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Aaron Lu <aaron.lu@intel.com>,
        linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        platform-driver-x86@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.i>
Subject: Re: [PATCH v5 0/4] Fix Win8 backlight issue
Date: Sat, 12 Oct 2013 16:10:51 +0200
Message-ID: <2087267.6s6y3mUdZL@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381557246.3261.67.camel@scapa>
References: <1381498066-16011-1-git-send-email-aaron.lu@intel.com> <3899323.lQYrFPeQhE@vostro.rjw.lan> <1381557246.3261.67.camel@scapa>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3359930.BymEqmo68p"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3359930.BymEqmo68p
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Saturday, October 12, 2013 07:54:06 AM Yves-Alexis Perez wrote:
> On sam., 2013-10-12 at 01:27 +0200, Rafael J. Wysocki wrote:
> > If we are to use a Kconfig option, why don't we use one instead of rather than
> > in addition to a command line option?  Say, we have
> > CONFIG_ACPI_VIDEO_WIN8_WORKAROUND and if that is set, the code will work like
> > the previous version of the Aaron's patchset (the one without
> > video.use_native_backlight)?
> 
> Doesn't this mean user will have to rebuild distro kernel in order to
> test behavior?

Yes, it does, which is a good point too.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart3359930.BymEqmo68p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJSWVhzAAoJEILEb/54YlRxfvkP/1Yf7ipPGKyRcg35BBkqq9jt
Ye1FNtnfVu9/v/RMMqZZMcS75+beQiqC5Xu78Ii9KadCkcRpXwt8wrucVc0yxlvx
YT0k+rE3AvwhncZqkT4K48RNS2vOaJhbEuIyOpIR/32X59LO4sY9oNgjE8rEfVWw
04QwCRQtgnsyxvosVBdQjPLJ7OwjNh17MLL9aiSW1Ail8sc3wBmUQLxtA2sfUWEA
MJN8EEsHyzQhBnFlmukzBt1ZAJk8x4l5Ty8SRqfy4cKGsl8FytUzI8u86fHFycd4
JaIgvNg6ngn5E4sxbKh4E4aM2Zg11Jkx00nY0yoZUBFZt9sgZQhA9I7IsdyAIMeG
8k/SpHAqw3jvWY1dWHwE21zZ3XEz3S/eDUubrFRe8JruBNsnxAllb2jARGD2M2c7
4JLjo3bh/0Fn7ySkQ1f52KlG/VWUx6AEu5rt6DmF37zLyil7NN11njcucjUIWDfD
qglwxtVke+0NRRiMNGH8HhujjpfR8vhc4k9ixAR6zWK1U5QIeQ0r29/DuaLfOjZ+
TkuQBxDQQWY/y4WFMIZQhA6WCAw8QMG1P84/gJ9mJmWEb/xO0X21hOaLRsVKwxaI
fXO/Ld5hNolfi6VHc7Vgqgv/+ndLdZciCRl4dttD4fLWu5+tSfKpq69O9aAXUPEY
sAnpSXfJK9GsNgfTRibW
=T8xp
-----END PGP SIGNATURE-----

--nextPart3359930.BymEqmo68p--

