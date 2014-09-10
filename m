Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaIJP2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:28:12 -0400
Received: from antcom.de ([46.38.233.243]:54327 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaIJP2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:28:10 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 11:28:09 EDT
Message-ID: <54106CC2.5080606@antcom.de>
Date: Wed, 10 Sep 2014 17:22:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Icedove/30.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: robh+dt@kernel.org, riku.voipio@iki.fi, cooloney@gmail.com,
        rpurdie@rpsys.net, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH] leds: Add DT support for leds-pca9532
References: <1410269280-8761-1-git-send-email-stigge@antcom.de> <17734612.3IvPuVrruO@wuerfel>
In-Reply-To: <17734612.3IvPuVrruO@wuerfel>
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 08:08 PM, Arnd Bergmann wrote:
> Is this a full PWM controller? If it is, it would be better to also
> provide a #pwm-cells property and register the device with the PWM
> subsystem to allow arbitrary users.
> 
> If the PWM is only really usable for LED, it's probably enough to
> leave this used by the LED subsystem.

Right, this PWM is really only intended for LED use (as already done w/o
DT).

Sending the updated patch.

Roland
