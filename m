Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaFMPaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:30:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37137 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaFMPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:30:18 -0400
Message-ID: <539B1795.1060507@wwwdotorg.org>
Date: Fri, 13 Jun 2014 09:24:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Marcel Ziswiler <marcel@ziswiler.com>
CC: thierry.reding@gmail.com, arm@kernel.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch
Subject: Re: [PATCH v2 1/3] arm: multi_v7: enable igb, stmpe, lm95245, pwm
 leds
References: <1741a33cd88cd5525f3c50c0e0cacc0853a3512a.1402350905.git.marcel@ziswiler.com> <201406131610.18048.arnd@arndb.de>
In-Reply-To: <201406131610.18048.arnd@arndb.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 08:10 AM, Arnd Bergmann wrote:
> On Tuesday 10 June 2014, Marcel Ziswiler wrote:
>> The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
>> i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller, PWM
>> LEDs generically accessible from user space and an LM95245 temperature
>> sensor chip. The later three can also be found on the Colibri T30
>> module.
>>
>> While at it move the NEON entry down to its proper place to have it all
>> nicely ordered again.
>>
>> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
> 
> Stephen, Thierry,
> 
> do you want me to queue it up directly, or do you want to put it into
> a tegra fixes branch?

Taking this first patch through arm-soc is easiest to avoid conflicts on
the shared file. I'll take 2 and 3 through the Tegra tree.
