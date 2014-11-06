Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaKFE55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:57:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53038 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaKFE5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:57:54 -0500
Date: Wed, 5 Nov 2014 22:58:19 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Todd Poynor <toddpoynor@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v5] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
Message-ID: <20141106045819.GB6272@saruman>
Reply-To: <balbi@ti.com>
References: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org>
 <20141105194047.GQ6548@saruman>
 <CA+RfmHZbsR0Q2X-4Pj1dwi1Qzpkf2K+e-JkfSqutaY=PhJckaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <CA+RfmHZbsR0Q2X-4Pj1dwi1Qzpkf2K+e-JkfSqutaY=PhJckaA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 10:04:01AM +0530, Kiran Raparthy wrote:
> Hi Felipe,
>=20
> On 6 November 2014 01:10, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Nov 04, 2014 at 03:30:54PM +0530, Kiran Kumar Raparthy wrote:
> >> From: Todd Poynor <toddpoynor@google.com>
> >>
> >> usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
> >>
> >> Some systems require a mechanism to prevent system to enter into suspe=
nd
> >> state when USB is connected and enumerated in peripheral mode.
> >>
> >> This patch provides an interface to hold a wakeupsource to prevent sus=
pend.
> >> PHY drivers can use this interface when USB is connected and enumerate=
d in
> >> peripheral mode.
> >>
> >> A timed wakeupsource is temporarily held on USB disconnect events, to =
allow
> >> the rest of the system to react to the USB disconnection (dropping host
> >> sessions, updating charger status, etc.) prior to re-allowing suspend.
> >>
> >> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> >> Cc: Felipe Balbi <balbi@ti.com>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: linux-usb@vger.kernel.org
> >> Cc: Android Kernel Team <kernel-team@android.com>
> >> Cc: John Stultz <john.stultz@linaro.org>
> >> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> >> Cc: Arve Hj=F8nnev=E5g <arve@android.com>
> >> Cc: Benoit Goby <benoit@android.com>
> >> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> >> [kiran: Added context to commit message, squished build fixes
> >> from Benoit Goby and Arve Hj=F8nnev=E5g, changed wakelocks usage
> >> to wakeupsource, merged Todd's refactoring logic and simplified
> >> the structures and code and addressed community feedback]
> >> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> >
> > you still didn't get this right. I asked that you introduce
> > usb_phy_set_event() as a separate patch, then make PHY drivers use it
> > and only on a third patch should you hold a wakeupsource.
> Thanks for your time.
> Sure,I'll resend the patches as per your suggestion,could you please
> let me know whether you are okay with this new approach?.
> This will help me to consolidate all your inputs in new patch set.

I'll review again in the morning, sure.

cheers

--=20
balbi

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWv/rAAoJEIaOsuA1yqREOgAP/0vAxYIMhHkrytfpRMjWFJRP
L74AeozjEetvXXMIelTOZiH/nvybV+7fg8mOa6hzQM3nrUddEkjFeiIlxQzDMGdK
DDUFt7gt7MXeX9eHAV3at4ymSG+3NNQXV+Q1Cu+YWqvTuF9iisMJXYIQIonxpf1e
ggzHtrnIHpkKZPLkKqsNIfo7X+Q63FqiUe5qfXiBGT6/Zxy/ipxXpoUXHBNY9nSX
7uADGZxyCMHTnDsA4a1TwpTFuybalvOq3JrpedVfYOgq+ruFai5fmJLEj6jIFSAA
+ifAYz2rv5d+8VWxh8z01jIqRYDwfKgMtjdbAZX3rYwtheFyFPWXZbdps5B87rtc
0bC7I1qwIWC7qaUA5ooR7znug1hIhh0icAGw+13VuBEH+Y9D7hIKra8tdzLi7C4F
kB00XbOVlqcESP9IH8/Ve3fuGFSJc73F8eIjnLiVt1i2273o2kEg5vUAS4ew313R
kP3ze9HclDGA5ClVAoBKrPKONCjAIdCRWgvrouPk+GvXYa7uljEn3cyU5YpVnuHX
RvQK0laxKLzBgLwUmQ9ZMeQ/vyDux210saTfwpLl9zlgH+EgqYUwouiOsAtD0WNA
jVw0eC2J+e4umaVJ2PDO8A40DhPiww95qvqvX5kGWwiylP4bij5XJTOb1JUmxcpt
UWG7Im+r+zILS6zXjCxk
=1IDe
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
