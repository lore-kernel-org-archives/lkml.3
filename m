Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaFEW5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:57:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43705 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaFEW5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:57:15 -0400
Message-ID: <5390F5C7.5070301@wwwdotorg.org>
Date: Thu, 05 Jun 2014 16:57:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] of: Add NVIDIA Tegra XUSB pad controller binding
References: <1401894990-30092-1-git-send-email-thierry.reding@gmail.com> <1401894990-30092-2-git-send-email-thierry.reding@gmail.com> <53909F31.4050603@wwwdotorg.org> <20140605220833.GA28817@ulmo>
In-Reply-To: <20140605220833.GA28817@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Pkt1FkuIKMqMg0rRt6J2mfxrRb13DSu3c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pkt1FkuIKMqMg0rRt6J2mfxrRb13DSu3c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/05/2014 04:08 PM, Thierry Reding wrote:
> On Thu, Jun 05, 2014 at 10:47:45AM -0600, Stephen Warren wrote:
>> On 06/04/2014 09:16 AM, Thierry Reding wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> This patch adds the device tree binding documentation for the XUSB pa=
d
>>> controller found on NVIDIA Tegra SoCs. It exposes both pinmuxing and =
PHY
>>> capabilities.
>>
>>> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra12=
4-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegr=
a124-xusb-padctl.txt
>>
>>> +- #phy-cells: Should be 1. The specifier is the index of the PHY to =
reference.
>>> +  Possible values are:
>>> +  - 0: PCIe
>>> +  - 1: SATA
>>
>> Those values are defined in
>> include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h. I personally conside=
r
>> the <dt-bindings/> header files to be part of the binding itself, rath=
er
>> than being derived from the binding. As such, I'd suggest the followin=
g
>> changes:
>>
>> * Make this patch 1 not patch 2
>> * Move pinctrl-tegra-xusb.h into this patch.
>> * Remove the list of values above, and replace it with the text "See
>> <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the set of valid values=
".
>=20
> I remember discussions where people explicitly said that relying on the=

> symbolic names in the DT bindings was a mistake because it would mean
> that everyone would need to have access to a mechanism similar to what
> we have in the Linux kernel (and that the header files would always nee=
d
> to be shipped with the DT bindings).

The entire point of the headers is so that the binding definitions and
code using them can't get out of sync. In my opinion, the headers *are*
part of the bindings, so of course anyone either reading DT bindings, or
parsing DT, must have the headers, and hence the headers must be bundled
with the DT files or with the bindings wherever they go.


--Pkt1FkuIKMqMg0rRt6J2mfxrRb13DSu3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTkPXHAAoJEJuNpwkmVCGczZgP/1UMgpmOSc+Wc4lu7V2FBINe
chgGWejm/sdvWSEQ1vk9Uwf4wcrwy/z1eCW14tLaRxMvwm7ZSRMp29NngXUaegb4
AVfTih6pH2/FYmvduAFmCEFFDGgFa8s3CkWis5qxg/J1NbhmojjVU6Na3tE2ueO1
fCHHWRzTkaNu9PL+jUlb2Zn9swKSgYlGFE74XJkYXXvK49W7S9Tjq8VS7/gAJ3AZ
4U0JQoo7tUtTlQQ9Sd9nvsw5JsEaK5Nhsb7wTwzB9wlOkAl+9yXzo1ChaY7F/E//
/pJrCpSxdGGHefHM0OygWLWGokTNP2hh1JBOj2Sfn/Dk+qEQtR6YfJTu0uu3b31m
0WHZ/3LyGMzX2a96N05xSaE/vo+1ysz65FkwaicnBBFOZXjhfikWiqomOEgTbG9G
7J/OBf8UZPm63Nt4oD0I72rrGoeuzi5ohkTWGCdFJ3Rdqdn2HqkfsosqyHOydW52
4gev36hcxgHNjSV0Yxrh5djUjAE55tPHOlv4ZeVHWTvm1b7IuQQ9KyRvYdlxHkZS
Syksxu8SeDv5+qyYew5a4/oxw8W8vQRJ7XFkbzAyx/gFC9+yfrn9iDidNFyTBYRc
MdUKVf1US79VCeBUqtY775EFJ6kJYBGvb7MvY+O2YdTCYPfIdN8su4duD7NZZCOo
f5gOFSnCOrR8/6pJO+N1
=lXuH
-----END PGP SIGNATURE-----

--Pkt1FkuIKMqMg0rRt6J2mfxrRb13DSu3c--
