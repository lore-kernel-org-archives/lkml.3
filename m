Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaB1KpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:45:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43824 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaB1KpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:45:14 -0500
Message-ID: <531068AB.5060600@ti.com>
Date: Fri, 28 Feb 2014 12:44:59 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <kys@microsoft.com>,
        <abgupta@microsoft.com>, <haiyangz@microsoft.com>,
        <jasowang@redhat.com>, <devel@linuxdriverproject.org>
Subject: Re: [PATCH v5 0/2] hyperv-fb: add support for generation 2 virtual
 machines
References: <1393411885-14895-1-git-send-email-kraxel@redhat.com>	 <53105077.4090102@ti.com> <1393582795.3364.5.camel@nilsson.home.kraxel.org>
In-Reply-To: <1393582795.3364.5.camel@nilsson.home.kraxel.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="7XKaoJDxL4T9AHlMatrCgdgd2U9f61E7k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7XKaoJDxL4T9AHlMatrCgdgd2U9f61E7k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 28/02/14 12:19, Gerd Hoffmann wrote:
> On Fr, 2014-02-28 at 11:01 +0200, Tomi Valkeinen wrote:
>> On 26/02/14 12:51, Gerd Hoffmann wrote:
>>>   Hi,
>>>
>>> This patch series adds support for uefi-based gen2 virtual machines
>>> to the hyperv-fb driver.  It depends on a few vmbus changes which are=

>>> staged in Greg's char-misc tree (and linux-next).
>>
>> Depends how?
>=20
> Will fail to build without the vmbus patches.
>=20
>> Patches that depend on other patches should be merged via
>> the same tree to avoid compile or functional breaks.
>=20
> I think Greg will happily merge them through char-misc if he gets your
> fbdev maintainer ACK for the patches.

Ok. It's usually good to mention if only an ack is needed (and from
whom). You did send this to fbdev, and said "please apply". So I already
applied it, until I realized you said there are dependencies.

So:

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--7XKaoJDxL4T9AHlMatrCgdgd2U9f61E7k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTEGirAAoJEPo9qoy8lh71jxwQAIGAgDaZ7RvyV3U82uHWLLj8
Ck3yrroFASIplen6CLrdIFA2rv1jgnDuRrSZ/SpYHd8M3rqfFD9G7ASFdRy9AVzp
UjM86Rgbot9HhOfeWis57oQAbJRw41FKwj7bniykElK2Wdrw+0LJL55bg6kBgO3p
cI0KXI7MDbi1hdHJZdHs+X1gcEu548zHq6lw4cw4Gmz18ktB7sJRY9Hhi1T3ddwb
cCJi6DKvKQwDZFhpBHnsirbMdhwSmQJ1lRrx5B3mDYyR/aGaVU3SP5vukSTwX2ZW
UpVnID2P0xvt54tHB7VCYmXbDebCJawH7KedCfPdpT22AacJF1WsGvNjeR4WsNhq
Q3V5BrrNNQoC+1XX/HFXJVo1Wmw6O7zBFEc552/N3QIWnMbR0SSfuIINCxvQ8D/r
n8Lbk+7nLLcfJmz6YISX/hLedlqUFhYzCancNp7pjdlmg0jFABuCwDtB3wpcDnN2
PZkRqwRLwd5NesWGfHAuL6aroxgKr07Ps0PHKDNAcKoQQ0S4ryBVsGndtt1/1qOp
eqxTrKEfJtTz4O7KzNkuuhIbUti+OutRrgiyBOMdr4kJ3g9p9V1G4WRzuyr8hbf9
xCLBlbLvtKAPDTtGexHYr/lBfehoVpJ3tNjSlS3sKu0escWTjFwtOOuPimCse/Mc
5wgAy3Pk4ap+SmnDPMf/
=2oE+
-----END PGP SIGNATURE-----

--7XKaoJDxL4T9AHlMatrCgdgd2U9f61E7k--
