Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbaGWPNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:13:22 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:26627 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932596AbaGWPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:13:19 -0400
Message-ID: <53CFD109.2050005@itdev.co.uk>
Date: Wed, 23 Jul 2014 16:13:13 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 04/15] Input: atmel_mxt_ts - implement device tree support
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk> <1404399697-26484-5-git-send-email-nick.dyer@itdev.co.uk> <53CECB6C.2030207@wwwdotorg.org>
In-Reply-To: <53CECB6C.2030207@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 21:37, Stephen Warren wrote:
> On 07/03/2014 09:01 AM, nick.dyer@itdev.co.uk wrote:
>> From: Stephen Warren <swarren@nvidia.com>
> 
>> diff --git a/Documentation/devicetree/bindings/input/atmel,maxtouch.txt b/Documentation/devicetree/bindings/input/atmel,maxtouch.txt
> 
>> +	touch@4b {
>> +		compatible = "atmel,maxtouch";
>> +		reg = <0x4b>;
>> +		interrupt-parent = <&gpio>;
>> +		interrupts = <TEGRA_GPIO(W, 3) GPIO_ACTIVE_HIGH>;
> 
> Oops. s/GPIO_ACTIVE_HIGH/IRQ_TYPE_LEVEL_LOW/ there; I evidently typed
> something stupid into the doc when I wrote it!

OK, fixed this. I thought it was some tegra quirk I wasn't aware of!
