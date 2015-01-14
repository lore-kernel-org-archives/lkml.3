Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbbANRFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:05:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59517 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbbANRFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:05:08 -0500
Message-ID: <54B6A200.4040209@wwwdotorg.org>
Date: Wed, 14 Jan 2015 10:06:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>, lee@kernel.org
CC: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: dts: add bcm2835-pwm bindings
References: <1421227134-8590-1-git-send-email-bart.tanghe@thomasmore.be>
In-Reply-To: <1421227134-8590-1-git-send-email-bart.tanghe@thomasmore.be>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 02:18 AM, Bart Tanghe wrote:
> To probe the bcm2835-pwm driver properly, this dts bindings has to be added
> to the bcm2835 dtsi file.
> In expectation of a bcm2835 clock driver, I've added fixed-clock clock binding.
> ---
> Changes in v3:
>   - node added by reg value

The pwm node still seems to be in the wrong place. Sorting by reg value, 
it should be after i2c@20205000 and before sdhci@7e300000, as I 
mentioned before.
