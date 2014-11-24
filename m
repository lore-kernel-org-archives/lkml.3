Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaKXOiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:38:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36521 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbaKXOiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:38:10 -0500
Date: Mon, 24 Nov 2014 08:38:19 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH v1 2/3] usb: phy: Handle per-PHY event for connect and
 disconnect events
Message-ID: <20141124143819.GB20705@saruman>
Reply-To: <balbi@ti.com>
References: <cover.1416547297.git.kiran.kumar@linaro.org>
 <7a23b5f0af4463aea85384b6a67678b9c41b9d2d.1416547297.git.kiran.kumar@linaro.org>
 <20141121151105.GC7508@saruman>
 <CA+RfmHZo4FuH6-Z8+VFY7Ao5QVD-VmfdCm17ZrB6f7J8Xpo-Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <CA+RfmHZo4FuH6-Z8+VFY7Ao5QVD-VmfdCm17ZrB6f7J8Xpo-Aw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 21, 2014 at 09:13:00PM +0530, Kiran Raparthy wrote:
> On 21 November 2014 20:41, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Nov 21, 2014 at 11:31:21AM +0530, Kiran Raparthy wrote:
> >> usb: phy: Handle per-PHY event for connnect and disconnect events
> >>
> >> When usb is connected and enumerated in device mode or when usb is
> >> disconnected,call usb_phy_set_event from phy drivers to handle per-PHY=
 event.
> >>
> >> Cc: Felipe Balbi <balbi@ti.com>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: linux-usb@vger.kernel.org
> >> Cc: Android Kernel Team <kernel-team@android.com>
> >> Cc: John Stultz <john.stultz@linaro.org>
> >> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> >> Cc: Arve Hj=EF=BF=BDnnev=EF=BF=BDg <arve@android.com>
> >> Cc: Benoit Goby <benoit@android.com>
> >> [Original patch in Android from Todd]
> >> Cc: Todd Poynor <toddpoynor@google.com>
> >> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> >
> > this patch doesn't apply, please rebase entire series on my testing/nex=
t.

your rebased version didn't apply either. Can you make sure you're
rebasing on top of my today's testing/next branch ?

cheers

--=20
balbi

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc0LbAAoJEIaOsuA1yqREWcMP/1aTlSVt6YjuOSnnzj+S+sI5
425lpOA4uOaUCjSkyLchBn7sGHGgq1tfeAJFigt9T8EFJkkqpEAkYsNaS9KdU1Ev
HLMV6clZVZVEy+YRjgH23FAxRtE/CTrovpQl6jL5Kiuc71YGiIgjsAO2PB5uV9jz
s9NBlneQnwnqc5hjyNK5C086gwtrXgntn30rv1G4HY8ir+Q8Wpq0zn6VW80fVR0f
4CrbRx6xa/A5OYwDNXDtMWjXEibX10QVdE4T0dwuPRrxf0hPD/8xFUK3DSHTQrl/
+6Rczkb48vK69EdvsjP4ATkZ1U+8QL+jF4u5qG9aPnyg5HMW3D9v6gQjFKRNxTtX
+G9XJFGYa0wxdqhasLF02DMoebjdVvI7QKEsOHJUV7avcY2/qIS2j6BViRSA2Uxc
WiV+Ft/V9llr/NWQg8mjx8P4Ep3C9FA6KKQCWdlVVlHY7hBrPbP3tqRqbdqJ3ChS
UUtAGIQeCp+dfxMeyeYM83EGqxsiNGAGpgPv76Blu2godrXrULiiLW14/9d9CUZM
KKgJohLwqVVnMsVlQYMZpeNb7KiaVBfbYKhQpI/PUyKvwBsmmQwJoxJ9mu2jytg8
Ib0OVtcZg08P4hC6sZ+dkzVXdya5rCpWPdl5yG3bqWu5cqmMt1kqpxCLPfg+SiyC
kLEkuNvQ5qkEpf1+WaA+
=r1Rm
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
