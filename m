Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3LSTDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:03:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43359 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3LSTDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:03:22 -0500
Message-ID: <52B342F4.1070400@wwwdotorg.org>
Date: Thu, 19 Dec 2013 12:03:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Laxman Dewangan <ldewangan@nvidia.com>
CC: anton@enomsg.org, dwmw2@infradead.org, mark.rutland@arm.com,
        rob@landley.net, ijc+devicetree@hellion.org.uk, swarren@nvidia.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: AS3722: add dt node properties for system power
 controller
References: <1387457821-12509-1-git-send-email-ldewangan@nvidia.com> <20131219130610.GI27373@lee--X1>
In-Reply-To: <20131219130610.GI27373@lee--X1>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 06:06 AM, Lee Jones wrote:
> On Thu, 19 Dec 2013, Laxman Dewangan wrote:
> 
>> ams AS3722 device supports the power off by turning off its all rails.
>>
>> Add dt node properties to enable this functionality on this device.

>> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt

>> +functionality from ams AS3722:
>> +ams,system-power-controller: To enable the power off functionality through
>> +	device.
> 
> Do what with it? "on", "<1>", something else?

It's a Boolean property, so just add the name to the DT, no value.
Admittedly the binding should state this.

The series,

Tested-by: Stephen Warren <swarren@nvidia.com>
