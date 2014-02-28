Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaB1S0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:26:14 -0500
Received: from arlo.cworth.org ([50.126.95.6]:59189 "EHLO arlo.cworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaB1S0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:26:12 -0500
From: Carl Worth <cworth@cworth.org>
To: Ping Cheng <pinglinux@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: wacom: Fixes for stylus pressure values for Thinkpad Yoga
In-Reply-To: <CAF8JNh+7p7-cNkBv3CB3ZVsi7JrqzPf1bdzsA4rJqKUcY=dZ0Q@mail.gmail.com>
References: <1393454296-32735-1-git-send-email-cworth@cworth.org> <CAF8JNh+7p7-cNkBv3CB3ZVsi7JrqzPf1bdzsA4rJqKUcY=dZ0Q@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 28 Feb 2014 10:26:05 -0800
Message-ID: <87sir36qma.fsf@yoom.home.cworth.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Ping Cheng <pinglinux@gmail.com> writes:
> Thank you for the heads up. I believe Jason's patchset 4 of 4
> (http://www.spinics.net/lists/linux-input/msg29435.html) fixed the
> issue for your device and for other's. The patch was submitted last
> month. If you can test the set on your device and give us a Tested-by
> here, it will help Dmitry to merge the patch upstream.
>
> Thank you for your effort.

Thanks, Ping.

Patches 2, 3 and 4 of Dmitry's series do everything that my series does,
(and a bit more since he also fixes the "unsigned char" for cases
besides the specific one I hit).

So those all get my:

Reviewed-by: Carl Worth <cworth@cworth.org>

I'll follow up more if I get a chance to test these as well.

-Carl

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJTENS9AAoJEGACM7qeVNxhy2gP/2ZRlDEBp2gtcQvP86rcx8ZU
1/qJhTWrq9d+FrA2UhHjVo8W/7KRL72QPUQuJST74clo3HOr4lVRhgXlcP3ljt30
OQ13cYAit+t2vtDL46LWIx00Uh8vfMYCbXQi6Hl4WveNpkiEmBI26VQm1RMqH6gg
KKOt790pnmtcqmBmzE9Nlo/mSDMdtLTsX4BSdeJ+ZXhlVVgUw2SRjqzck1aBdLZl
lqljWhG/7uhzaWxx/IZyGQAqTtS+GC5WTjoFpQ1qzRzAHlkjN9FYYw9xwxlIsbYO
jxU9Rt7mxQFEAFnxF7l146EVmkDNsFfnEpEgPjJgIAnxH2ntsGtqvMaWz6ZO85MU
UgyDkHnLT1moqM4Qr2TDya0mDZwLuINno2kOEdCZvfpTJape88yicy1abWi8DHo4
Ui7dP353kf4RdtleEREzaMVpyGQLNRZ6UQFlo1yIkebAuFlmvRb8pkMxXtzqTJ64
PyxKhTpBDnBB/CEbWjlGoyihxqUdiwvnhiKNV2qW1Der6wAYBtcmH0B3OgSPCNMu
wH7g1/jm0ohr3rxrl0fEt9FoGEVqtOxKieCgIRG8+yzCQ2TjzsbqetE18IvY4+sK
RuvsvJBsjNPl/UAroKCfxKZIGD7u9agXKXq4MJuVJq4LhQBaJF+iWOQSs+dw3WED
poBAdjUbL3gyxeAQ05CO
=zXUm
-----END PGP SIGNATURE-----
--=-=-=--
