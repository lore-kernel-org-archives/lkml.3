Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbaFDGWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:22:04 -0400
Received: from mout.perfora.net ([74.208.4.194]:54835 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbaFDGWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:22:01 -0400
Message-ID: <538EBACB.70100@ziswiler.com>
Date: Wed, 04 Jun 2014 08:20:59 +0200
From: Marcel Ziswiler <marcel@ziswiler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 2/3] arm: tegra: enable igb, stmpe, i2c chardev, spidev,
 lm95245, pwm leds
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <39a8704a4c8170d6b0620a1e5e44042eae6d8810.1401665237.git.marcel@ziswiler.com> <538CA24B.1010602@wwwdotorg.org> <538CA635.4050502@ziswiler.com> <20140602221627.GP31751@sirena.org.uk> <538D64FD.2010909@ziswiler.com> <20140603094537.GQ31751@sirena.org.uk>
In-Reply-To: <20140603094537.GQ31751@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:kBmjMysnWWJm6WjrLtnBtS4JXldtz2J6Ynb3a2cI49X
 UbqOFSVyNJaIJyJOmq7lOXousQLXBPJmK1YNJN8UXrARiZ1sj0
 aG95EMpAy26PQ20F0yZtYOBklwPVlMnL7yugIMh/RdVMN9CB+t
 0qXnoYyzrEunpZ5wY97wgZZn1GtJFUANg/eMim3FM4dqoF6ntt
 qbu9aX/+HPdmOspB8ZPR0NQt/l5hnwzalAMu2SOIqJByvfOQUc
 ck4wsiew4QuS0IkndpNhIt8SSUgUdtSSc8KGieumHT+WqfND5T
 pWCr7fiJHsyZCre1sxYyxhLafsRY8ytXv0RMLL2q3Qbe3Q0zI0
 t0B/8CqeaSRfcTLfui9s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 11:45 AM, Mark Brown wrote:
> When you say "generic user space access" you are describing a specific
> detail of how this device happens to be controlled with your software.

No, not at all. In fact I did not even specify neither the exact type of 
device apart from it being a SPI device nor any property of the software 
apart from the generic user space access thereof implemented in the 
Linux kernel. I really don't see any difference to i2c chardev which is 
already enabled in multi_v7_defconfig.

> This is not a description of your hardware, it is a description of how
> it is controlled with your current software.

Sorry, but I really don't know what you are referring to. It's a pure 
hardware description of some pins being the SPI bus namely MISO/MOSI and 
the clock plus an accompanying chip-select pin.

I fear for some reason or another you have some affinity against spidev 
which strikes me odd. Admittedly it is not perfect but it is the only 
generic SPI user space access currently implemented in the Linux kernel 
and so far did its job perfectly for many of our customers.
