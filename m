Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaFBUdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:33:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34378 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFBUdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:33:42 -0400
Message-ID: <538CDFA2.5020704@wwwdotorg.org>
Date: Mon, 02 Jun 2014 14:33:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 3/3] arm: tegra: initial support for apalis t30
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <b470c9c8631a6ef021d140192eb07006de3cfd93.1401665237.git.marcel@ziswiler.com> <538CA5C3.5050709@wwwdotorg.org> <538CDC08.7020106@ziswiler.com>
In-Reply-To: <538CDC08.7020106@ziswiler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 02:18 PM, Marcel Ziswiler wrote:
> On 06/02/2014 06:26 PM, Stephen Warren wrote:

>>> +    pwmleds {
>>> +        compatible = "pwm-leds";
>>> +
>>> +        pwm3 {
>>> +            label = "PWM3";
>>> +            pwms = <&pwm 1 19600>;
>>> +            max-brightness = <255>;
>>> +        };
>>> +        pwm2 {
>>> +            label = "PWM2";
>>> +            pwms = <&pwm 2 19600>;
>>> +            max-brightness = <255>;
>>> +        };
>>> +        pwm1 {
>>> +            label = "PWM1";
>>> +            pwms = <&pwm 3 19600>;
>>> +            max-brightness = <255>;
>>> +        };
>>
>> Nit: Why not sort those nodes in numerical order?
> 
> Sure, the only question is ordering based on what. I choose the actual
> Tegra PWM instance while you propose to use our Apalis instance
> numbering which in this particular case turns out to be the opposite but
> makes us even more happy to comply.

Sorting by reg value, or if there is no reg value then alphanumerically,
is what I've tried to (remember to) require for the Tegra DTs.
