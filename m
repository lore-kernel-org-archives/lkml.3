Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbbAOM3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:29:49 -0500
Received: from rhcavuit01.kulnet.kuleuven.be ([134.58.240.129]:55737 "EHLO
	cavuit01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753945AbbAOM3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:29:47 -0500
X-KULeuven-Envelope-From: bart.tanghe@thomasmore.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: D9AAE138030.A65D3
X-KULeuven-Information: Katholieke Universiteit Leuven
Message-ID: <54B7B2AE.3020309@thomasmore.be>
Date: Thu, 15 Jan 2015 13:29:34 +0100
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Bart Tanghe <bart.tanghe@thomasmore.be>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, lee@kernel.org
CC: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: dts: add bcm2835-pwm bindings
References: <1421227134-8590-1-git-send-email-bart.tanghe@thomasmore.be> <54B6A200.4040209@wwwdotorg.org>
In-Reply-To: <54B6A200.4040209@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really sorry. I've used the wrong source. I make v4.

Regards,

Bart

On 01/14/2015 06:06 PM, Stephen Warren wrote:
> On 01/14/2015 02:18 AM, Bart Tanghe wrote:
>> To probe the bcm2835-pwm driver properly, this dts bindings has to be added
>> to the bcm2835 dtsi file.
>> In expectation of a bcm2835 clock driver, I've added fixed-clock clock binding.
>> ---
>> Changes in v3:
>>   - node added by reg value
> 
> The pwm node still seems to be in the wrong place. Sorting by reg value, it should be after i2c@20205000 and before sdhci@7e300000, as I mentioned before.
