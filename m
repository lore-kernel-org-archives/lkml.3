Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaFBQYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:24:44 -0400
Received: from mout.perfora.net ([74.208.4.194]:52865 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbaFBQYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:24:41 -0400
Message-ID: <538CA531.2090006@ziswiler.com>
Date: Mon, 02 Jun 2014 18:24:17 +0200
From: Marcel Ziswiler <marcel@ziswiler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: thierry.reding@gmail.com, arm@kernel.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch
Subject: Re: [PATCH 1/3] arm: multi_v7: enable igb, stmpe, spidev, lm95245,
 pwm leds
References: <cc612cd3f24f01cfc8fd3e81b1027ff94862e8b4.1401700579.git.marcel@ziswiler.com> <538C9F83.1010800@wwwdotorg.org>
In-Reply-To: <538C9F83.1010800@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:uRxQHNSlpzMXSh3CO+lHJJOep5BdohRmyNjwajNizAz
 jOhZOMsVguRIwD0bc5D1xnN/6MJbTDK7cgd9vsrvaO+tPFuYqR
 a+f4eorJif7D9QgKfFqDPw4yTdr3CdWGs8fUefTEK33HR4jcLt
 JamwG8gYjfZllJuCgFHeoDEO+MMXDaDDr+ven/a2MQRi1gDkHG
 l2YLMW+QTrbp/5EAh9mqMKQBLTc7cbAtBWGGgdnYRzZf1yfuy7
 3CIKbF0IzR+TBqaFARNy2UqtFf2DTXQnekQphvH3IuPdMYdTmc
 YpllLaVfXQ+eqlIJByddeWceiF7eftwF/rs57p5NxVxCeGIi2V
 qy7jHADwkhcIqm+OzWH0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 06:00 PM, Stephen Warren wrote:
>> BTW: How about TEGRA_EMC_SCALING_ENABLE
>
> I thought a patch was sent to remove that. Perhaps the patch was only
> sent to tegra_defconfig.
>
>> ... MTD_M25P80 which depends on MTD_SPI_NOR
>
> I've seen patches to fix that too.

Yes, you are right. I have seen patches as well but none of them made it 
yet I guess.
