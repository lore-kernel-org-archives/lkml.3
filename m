Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaKZPoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:44:00 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60070 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZPn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:43:58 -0500
Message-ID: <5475F539.7070807@gmail.com>
Date: Wed, 26 Nov 2014 16:43:53 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] phy: add the Berlin USB PHY driver
References: <1416520406-1852-1-git-send-email-sebastian.hesselbarth@gmail.com> <5475D90B.9070908@gmail.com> <5475E2AE.6010905@ti.com>
In-Reply-To: <5475E2AE.6010905@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 03:24 PM, Kishon Vijay Abraham I wrote:
> On Wednesday 26 November 2014 07:13 PM, Sebastian Hesselbarth wrote:
>> On 11/20/2014 10:53 PM, Sebastian Hesselbarth wrote:
>>> From: Antoine Tenart <antoine.tenart@free-electrons.com>
>>>
>>> Add the driver driving the Marvell Berlin USB PHY. This allows to
>>> initialize the PHY and to use it from the USB driver later.
>>>
>>> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
>>
>> Gentle ping.
>>
>> Kishon, anything wrong with these two patches?
>
> It's already queued in linux-phy next.

Oh, okay. Thanks for the heads-up. I thought you'd be sending
informational mails when queuing patches. Looks like I missed
this one.

Anyway, Thanks!

Sebastian
