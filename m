Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaIZP4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:56:54 -0400
Received: from ring0.de ([5.45.105.125]:36018 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321AbaIZP4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:56:52 -0400
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: ring0.de]
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
Date: Fri, 26 Sep 2014 17:56:39 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, dbaryshkov@gmail.com,
        Christophe Kerello <christophe.kerello@st.com>
Subject: Re: [PATCH 1/5] power: reset: Add restart functionality for STiH41x
 platforms
Message-ID: <20140926155638.GB21641@earth.universe>
References: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
 <1406040752-25229-2-git-send-email-lee.jones@linaro.org>
 <20140926095628.GE4097@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20140926095628.GE4097@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Fri, Sep 26, 2014 at 10:56:28AM +0100, Lee Jones wrote:
> Dmitry,
>=20
> This patch-set has been on the list for some time (2 months) now.
>=20
> How would you like me to proceed?

http://git.infradead.org/battery-2.6.git/commit/f0745f3696e88b4055c6229e130=
6a78fbe503066

-- Sebastian

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUJYy2AAoJENju1/PIO/qatboP/it7jX8cMkzMHM3EP73a/XEX
j4Hxv9a6bSZrVhUDjqVFb/Ja7x6fKnj0W+E3erRchiEAS5yu9ctNnWdZRBtc08D6
meT3Zj1/FyeIWRxsLFG+7DYd96Dp+tsKnVu5ovEg8yGdAP2f4OY6FB3PYpJXoUJP
J5RBlE6RWxAChrl9Wdve3yk1/YM8a31VzTMJc+JdLZ67pSabZTmvG8CD0Qj1Ohip
mAURN2j3A4aHXKtnM6WozMKj+TppSiP8ownEeSpXnWFzPMqECQnN6BQC7GK0ld1v
AKBP2WyusSsWYOws4knG7j4xZFJFybR++kzti6snTukOdiUoJygoZWmh7GUPTf9z
dBIPyVMV6S2BW2sjAjuPLgZN3NEU7VtmFRCg+nOA0rGwE44D8534J9/qSXfNJh/h
0FQL9dw2X6kVfn0qq+V/h4fPxleez62OMuW7FzplAqx+Fc82I7ClXytjJbkFst2U
GpGx62DpR+QHsLWHbdbIpqejgJbZeYe3MrOLdW/tKGot0Xeqt3Q3ozUNjQBi3TOp
qZGX8QB9y5mCyQU2VRWXHFP/M4yFHM8aRyZaqvTg+3IPMixcX7DIa/ikQbOUAo09
LXxbE3rJ6RX0UMRhDPx9ecwb7WyqsZK7RqjLsTZX0vHO3cnNMsk/qyw0FOiOOnf1
qMBwg/ZcyGpsAWdeJ3Gw
=mltv
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
