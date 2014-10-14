Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaJNWok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:44:40 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:40464 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaJNWoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:44:38 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: tecfacet <tecfacet@yahoo.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: Re: rotary encoder linux driver
In-Reply-To: <20141014084815.GC7958@localhost>
References: <1413163743.39490.YahooMailNeo@web160203.mail.bf1.yahoo.com> <20141014084815.GC7958@localhost>
User-Agent: Notmuch/0.18+69~g2295f35 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 14 Oct 2014 18:44:33 -0400
Message-ID: <87tx366zla.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Johan Hovold <johan@kernel.org> writes:

> On Sun, Oct 12, 2014 at 06:29:03PM -0700, tecfacet wrote:
>> Hello.
>>=20
>> I am interested in the rotary encoder kernel driver.  I am very new to
>> this linux kernel driver thing.=20=20
>>=20
>> How do I pass the gpio and interrupt stuff to the kernel module.. I
>> think it is thru the rotary_encoder.h file.. am I correct?
>
> That should be done through the device tree these days. The binding is
> documented in
>
> 	Documentation/devicetree/bindings/input/rotary-encoder.txt
>
> in the kernel source tree.
>
You may also be interested in the device tree for a BeagleBone cape that
I recently brought up which includes an encoder,

    https://github.com/bgamari/dtb-rebuilder/blob/heaterbone-3.14/src/arm/h=
eater-bone.dtsi#L248
=20=20=20=20
Cheers,

=2D Ben


--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUPadRAAoJEErkyLZmeNiDyMQH/3xfi3htAwh3+RxGf/LCBcBR
XlmM5qQXU54P4s1Bx6bJbQuKM/VXCnlGynBmoV9c+eZIkxQP0sane8ykRPKFc0M4
rYOCi7eJBdIHaBi7hBFCYgKeSRUA/ZFdSqRGLs+eAebGEOJK87gWYererZRAo1na
5pjalz+wiSRKTQJR32dKe1on/y3Fnd8hJq+aVQ35eIUrvLPdmDZexlM/ZqOw8RGh
5e6CyIv6H755Kk5QJnXJYBtfP9cru92+fe7uGxRFJwcV5qKwbZITclKbtur+Baeh
3+HOEQCMkYYBVsRXUWuRgMw/AGpknUHmF/UuhXe0rDqEXBbdFWRxhtfZO4mqCU8=
=MD7d
-----END PGP SIGNATURE-----
--=-=-=--
