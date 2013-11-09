Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3KIVY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 16:24:27 -0500
Received: from scrye.com ([75.148.32.185]:58655 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab3KIVYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 16:24:24 -0500
Date: Sat, 9 Nov 2013 14:23:56 -0700
From: Kevin Fenzi <kevin@scrye.com>
To: Jiri Kosina <jkosina@suse.cz>, Nikolai Kondrashov <spbnick@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
Message-ID: <20131109142356.6bf47526@voldemort.scrye.com>
In-Reply-To: <CAFv23Q=7L=PqV88XhEMiRfZ+5ZzNWUDXqP3TSpgNwvFvk4sTpw@mail.gmail.com>
References: <20131028150250.755b4cc8@voldemort.scrye.com>
 <CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com>
 <CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
 <5270C549.30201@gmail.com>
 <alpine.LNX.2.00.1311051051590.2779@pobox.suse.cz>
 <CAFv23Qkbkh2UGv1fFRApg1nCP5ysvBLnLeSW19JLeAfDmbJEsA@mail.gmail.com>
 <20131106102838.347b005c@voldemort.scrye.com>
 <CAFv23Q=7L=PqV88XhEMiRfZ+5ZzNWUDXqP3TSpgNwvFvk4sTpw@mail.gmail.com>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA512;
 boundary="Sig_/XPI9=FK4p_1AIfQcsoj3pGS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XPI9=FK4p_1AIfQcsoj3pGS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Nov 2013 16:10:07 +0800
AceLan Kao <acelan.kao@canonical.com> wrote:

> Hi Kevin,
>=20
> http://people.canonical.com/~acelan/elan_touchscreen/
> Here are the kernels, please test them one by one and tell me which
> one works. As your description, the first one should work, and the
> second one doesn't, I just want to make sure that, so I build the rc6
> and rc7 kernel to test. Thanks.

Thats very nice of you. :)=20

However, I run Fedora rawhide here, so deb's aren't too useful for me.=20

I just confirmed that:=20

kernel-3.12.0-0.rc6.git0.1.fc21.x86_64 is ok.=20
and
kernel-3.12.0-0.rc6.git1.1.fc21.x86_64 shows the issue.=20

So, thats between 3.12-rc6 and 57-g69c88dc
I'm setting up to build some kernels to bisect it.=20

git bisect start
# bad: [69c88dc7d9f1a6c3eceb7058111677c640811c94] vfs: fix new kernel-doc w=
arnings
git bisect bad 69c88dc7d9f1a6c3eceb7058111677c640811c94
# good: [31d141e3a666269a3b6fcccddb0351caf7454240] Linux 3.12-rc6
git bisect good 31d141e3a666269a3b6fcccddb0351caf7454240

Will let you know what I end up with, thanks.=20

kevin

--Sig_/XPI9=FK4p_1AIfQcsoj3pGS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJSfqfsAAoJEEs3sNgP+7teVlwP/iKCEvTPtYM3YiWeKmAH6tV7
ufnLPyoE0u5/HYT+SxpcUaqpxRWUEUhPqqoCwSSdjVcIHLf0ZuCNpk8veH+KJnIQ
74sAi5ftAOHFvxVMdXuXpNwxWkQfI6e7o5W+dBfNpZ7BVzFfHL5v5b2AfBWkcFmw
2q+39g6avKaSnBiZwobzoMLZPcn3krrIJhQSHB3jyqtWDzNTuHgNVjaj7adpBAn3
xKvW/tZRdRHSGGhvPjkrltQGyrawGdnqT8lrxbLk5jr6a2mOZL+F4WZm9ZDKA1SV
gj/+COXG58OWcmNiM9hinty7RX6OaHt5euj0Jbnec+aXIJGfP9EW45RGyhPszxsN
88oadBHKu81OiKLuZq63qhRN/lmKk6yp3/Koy6iwdPimdn3rUA+Tdnx8Tbr6vlg+
APBk/AFRoS+69wGwvuW8+u8/waK85EkzGDIVMpRhrsLKvmFQiVp7RROxYphXR4St
HG3so2M65DtR9I3igMXsQauAO5Hkv/Frnr2us2xiKYJIrxk9qzgqrfZPR2ztNe3F
D2rcXyxawv3ecB9g18eDKNVfuV0YEZp8SwIRGIWezCkRg4dObQ1vr1DWasNSz7nT
yRAT0byfLDsu5UNC9XR2JNtHhavrGr9GHkMz9liHidEKHwYhwkBTe3KcfO/jFEnC
WCmqp9nYFKo99ilgY18W
=nxcL
-----END PGP SIGNATURE-----

--Sig_/XPI9=FK4p_1AIfQcsoj3pGS--
