Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbaIZP5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:57:40 -0400
Received: from ring0.de ([5.45.105.125]:36045 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbaIZP5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:57:39 -0400
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: linaro.org]
	* -100 USER_IN_WHITELIST From: address is in the user's white-list
	* -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 26 Sep 2014 17:57:25 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, dbaryshkov@gmail.com,
        Christophe Kerello <christophe.kerello@st.com>
Subject: Re: [PATCH 2/5] power: reset: st: Provide DT bindings for ST's Power
 Reset driver
Message-ID: <20140926155724.GC21641@earth.universe>
References: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
 <1406040752-25229-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <1406040752-25229-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 22, 2014 at 03:52:29PM +0100, Lee Jones wrote:
> Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/power/reset/st-reset.txt | 11 ++++++++=
+++
>  1 file changed, 11 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/reset/st-rese=
t.txt
>=20
> diff --git a/Documentation/devicetree/bindings/power/reset/st-reset.txt b=
/Documentation/devicetree/bindings/power/reset/st-reset.txt
> new file mode 100644
> index 0000000..809af54
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/reset/st-reset.txt
> @@ -0,0 +1,11 @@
> +*Device-Tree bindings for ST SW reset functionality
> +
> +Required properties:
> +- compatible: should be "st,<chip>-restart".
> +- st,syscfg: should be a phandle of the syscfg node.
> +
> +Example node:
> +	restart {
> +		compatible =3D "st,stih416-restart";
> +		st,syscfg =3D <&syscfg_sbc>;
> +	};

http://git.infradead.org/battery-2.6.git/commit/b08fec2262c8dbb349fe9456586=
cf0724407e5ee

-- Sebastian

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUJYzkAAoJENju1/PIO/qaYwUP/RoxpvZD9VzkVjpT3F13xl4Y
wUfmW/vQAPeMbGIPR1x85KFCDBDuTtY0gHfHDnKpppQnj6l6dOQIVjmO1Fw6jG/y
oeV5+pUKLmBj3l9eeFBHWli76ksAVwnUzZ6zu2LY2DS6Qvn8oKJ46lIQ3LjDvWmf
MRz0ErAtn+orR4jBlzdWdHfPTxrcQP3eKEarGQkPzRN6JwJLMTcHuwo+N/ncowCW
T6kk63a6ivZsU8nngjORFNWeVhA+AssUV5Ne2ALDh/vXcIHsMH0DoyBH0Myic26a
AqFFQjeDCLiALgUaiQUwzDZpJQ1J/TfpL4k2BdqlPSahYoeyPyfpEdk1/h9pqd7w
tGeLYB0UxVGxECCikQYCSixjEjjW+jPARY624dJGC9hDCkjSnLX+AytcR1tzzDF6
BuYwVn7AuiXcui7BfyYh39BcYNsizsKhxF85VEimInL+dgq12USPrDXrlb5gVFT6
nI5JTKgv0XBwU+xKoqcv8wF1ZNYFHO3/ydBOgyS95t5Uyntrm9a2PZskn5OJ/PII
99qfT36hKfZngn+s/XbLdS50dwdBjwEZ4I9FHM3gqTF+jpBAe3mVLZdduI8YNMLk
Rwsi984nmiQ0aZAQSAMZXsL1UoykfNLXUcSckr80Z21Z6fG80ar5vZJAH9+vhLik
PNbaI4lfjSkDnxWDx0f7
=CWfB
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
