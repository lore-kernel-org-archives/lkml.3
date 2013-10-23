Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3JWWut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 18:50:49 -0400
Received: from ring0.de ([91.143.88.219]:43723 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab3JWWuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 18:50:13 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 24 Oct 2013 00:49:42 +0200
From: Sebastian Reichel <sre@debian.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv5 1/3] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131023224940.GA19522@earth.universe>
Mail-Followup-To: Rob Herring <robherring2@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1382560002-6299-1-git-send-email-sre@debian.org>
 <1382560002-6299-2-git-send-email-sre@debian.org>
 <52684C8E.6080802@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <52684C8E.6080802@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 23, 2013 at 05:24:14PM -0500, Rob Herring wrote:
> So a twl4030 device is only a power button? DT should describe the h/w
> not a node for a sub-function of a device.

No. TWL4030 is a companion chip for the OMAP3 processor. It provides
miscellaneous functionality, e.g.:

 * RTC
 * Watchdog
 * Regulators
 * Keypad Matrix
 * USB
 * Audio
 * Vibrator
 * GPIO
 * ...

One part of the functionality is the power button. The patch
assumes, that the twl4030-pwrbutton node is used as follows:

twl {
    /* ... common stuff ... */

    pwrbutton {
        compatible = "ti,twl4030-pwrbutton";
		interrupts = <8>;
    };
};

See also:
* Documentation/devicetree/bindings/mfd/twl-familly.txt
* Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt
* Documentation/devicetree/bindings/sound/omap-twl4030.txt
* Documentation/devicetree/bindings/mfd/twl4030-power.txt
* Documentation/devicetree/bindings/mfd/twl4030-audio.txt
* Documentation/devicetree/bindings/gpio/gpio-twl4030.txt

-- Sebastian

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSaFKEAAoJENju1/PIO/qaThIP/RIh/gXpohEecXYYShzhNfoz
LVoMrx876PcWtzUl79aXWKu5YvrWio2H2yoc/5VcS3zQTUEIWaXDRowVQ/Zm0ltb
Up+tNwP3IKQBjLXTAY8cUqXyqIerA9lxHlSSd2fEfdp8b5GwxKxBPRm7IZ2KZ3yO
YWvnPHXLcV6mTkthNQf4WHUUW4AmqRdwdtzbn4ZuqTwv5IPygUz3YdwVw0J0EXVK
fGdQN9PAGJ09APwYyTDbSOmmqG2mWqadr8OQiaHddrjDBZQ9SBFHoUovu8LfDJ92
4O5Dx1cG3xKVut5UXU1mvexLU/QHKzfCnc5lspRRwHAbzniH0zm5Rmcf7p3kK5ZF
9sSLGqJF2lqSJB3gDotmIanPXXggcF/Si21GBJQkaeW8mmYl7mi4Wa89dVyukZDE
1acFbTOrUbqa+W9TxyiPuQmbotVdus+RJi/aholbCC1HQK1xvJ3xEqNXT6rP43Og
6igAjKIgbY4TP2vb4wVrJdHpw8FVPtg0MqOF0tdmFCmQSzuXKMblzMUyhA+l+sq7
xB3o0kp8mrRGaF+Vmz4heuDDkhZoDAXcQ2LXl5e7iBXTyLrQ9IvbnkQNJbsxQxtx
T6nXURxqTD7wn2d5UMO7RvBm760Wa7rCa6PUPQWBZh54oXqkjGaLeq8gzXs/k+3u
OzlPrnZu2ulaaAcV2YEU
=VSpi
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
