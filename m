Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3LTQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:09:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39918 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3LTQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:09:57 -0500
Message-ID: <52B46BCA.1010709@wwwdotorg.org>
Date: Fri, 20 Dec 2013 09:09:46 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Laxman Dewangan <ldewangan@nvidia.com>
CC: anton@enomsg.org, dwmw2@infradead.org, mark.rutland@arm.com,
        rob@landley.net, ijc+devicetree@hellion.org.uk, swarren@nvidia.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] mfd: AS3722: add dt node properties for system
 power controller
References: <1387545840-2844-1-git-send-email-ldewangan@nvidia.com> <20131220134808.GD3709@lee--X1>
In-Reply-To: <20131220134808.GD3709@lee--X1>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 06:48 AM, Lee Jones wrote:
> On Fri, 20 Dec 2013, Laxman Dewangan wrote:
> 
>> ams AS3722 device supports the power off by turning off its all rails.
>>
>> Add dt node properties to enable this functionality on this device.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> I'm guessing I can use this as an Ack?

You mean for the DT binding? I'm not actually in MAINTAINERS for DT
binding reviews any more, but this binding change is identical to that
which appears in a bunch of other drivers, so I'd tend not to think it
needs an ack.
