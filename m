Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3CUVby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:31:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab3CUVbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:31:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
Date: Thu, 21 Mar 2013 21:31:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com> <201303211903.52383.arnd@arndb.de> <20130321201807.7cb04978@skate>
In-Reply-To: <20130321201807.7cb04978@skate>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303212131.07629.arnd@arndb.de>
X-Provags-ID: V02:K0:d4HoW+K6RvwNDwKToVZc8l0CPuKSZvW8Oj2akbvXdvJ
 hmgChjCeWOeJa2bgTbGBKVQXcYyP8qi/0fdxKb7pruvjTT3GuK
 YsCICpVExu9gb1eLzpOuh2EnxzuN5hV2rxwyMbNPkqIneZSol0
 0HFPay2D2AWMtZQqQQUwdfxNwGDHuwifNpqivzJS0CqjoeTH3B
 9ox8JY1Rp3rdNC3A5QaYn1VQYKVR6p/z8YCw91f39Rd4ccR75G
 QHfMuRES4gaNacva6KTvEs8hFnhHcyRyr71CkOtqWByEej4q5l
 IZ7yS976enK9icBY3OOr9nhl1dr3D1o6zzt3gu3kYC+5ijG0Pc
 192IJKtfUXNoqFZF1cY0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 March 2013, Thomas Petazzoni wrote:
> In the mean time can we do something like:
> 
>         soc {
>                 compatible = "simple-bus";
>                 range = <...>;
> 
>                 [... all the peripherals ...]
>         };
> 
> with the range = <...> property converting the peripheral registers
> base address (expressed as offsets in the reg = <...> properties of the
> subnodes) into the absolute physical address?

Yes, that is what Rob suggested you do.
 
> I'm planning to work on the DT binding for the mvebu-mbus driver as
> soon as the PCIe driver gets accepted, but it would be good to have an
> intermediate solution to get the LPAE support in.

Sounds good.

	Arnd
