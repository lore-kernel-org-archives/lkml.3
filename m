Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaLVPil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:38:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46060 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbaLVPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:38:38 -0500
Date: Mon, 22 Dec 2014 09:37:30 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH 3/3] usb: dwc3: add a quirk for device disconnection
 issue in Synopsis dwc3 core
Message-ID: <20141222153730.GA12815@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1418695828-605-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1418695828-605-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2014 at 10:10:28AM +0800, Sneeker Yeh wrote:
> Synopsis DesignWare USB3 IP Core integrated with a config-free
> phy needs special handling during device disconnection to avoid
> the host controller dying.
>=20
> This quirk makes sure PORT_CSC is cleared after the disable slot
> command when usb device is disconnected from internal root hub,
> otherwise, Synopsis core would fall into a state that cannot use
> any endpoint command. Consequently, device disconnection procedure
> might not be finished because sometimes endpoint need to be stop
> by endpoint stop command issuing.
>=20
> Symptom usually happens when disconnected device is keyboard,
> mouse, and hub.

you need to point us to the synopsys STARS ticket number. That's the
only way to reference this specific quirk. Add it to a comment
somewhere.

--=20
balbi

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmDq6AAoJEIaOsuA1yqREBvsQAJ5hAbSbFOq1rpAfsrVX6QIG
V+//vvw4jxayZT/pJhEhzihGa4EPA+A7mIncZ9wZ4hqclYqUnQmZvlnYHM2o2JPu
Yhwr/xs5YplmYK6prNU9ROUgfK7YrjoY2jj+DfHrwdg6i/bPaaH9YwvFFFklAYzL
FqPme1iqPU0Pg8hosOpclA1ikavMXEot31RqEPipBQUwFzwjVu0Eun5rWiTHEvhI
jqhMWv+jazCIJpBAlgVVrGc+r7nfQ4mkjhBaQcUwQ9HczYlv1Rg8tMMCzH1xB/+v
MdTqLIRXh9xej4unzTYmE5twX9Qo7rjadVaOnB1gEN7YQh5mGOq7n4YqS5t71Gzr
4D9E4uSlL8zqpYnYdZrXQiiAbOb3O8yDXa1LKc3ZAZ/QhhHfo8YfspO6I3QIjmtg
8Jsk/X05dkmlgCSXEnXtQCqBc4KpddHjH+1gziHOKio8Tte3eX2MFOZGk9q12heC
2dpUHeKokJWaEK66O6clzBIyDWWXyNQIDtEjaXZts+lUN/hzjz5GSWGv6c2Vpd71
VMIzr/chN6AJWAFoXNc827SVdEqQBcu4ziRR6mNJ/R99fdv52j3wtYJaf7z8vsiu
kZ8FuBW8coQZg7IapDFkbGWATLBRKxaeZl+NISFdUNl2UgPQqCe4IZlYvHqiVVZi
sGWJjgABKtq5Bp13ct48
=Au6Y
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
