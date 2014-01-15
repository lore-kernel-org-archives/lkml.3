Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaAOKQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:16:31 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:49334 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaAOKQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:16:28 -0500
Message-ID: <52D65FF8.2090901@cogentembedded.com>
Date: Wed, 15 Jan 2014 14:16:24 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, anton@enomsg.org,
        dwmw2@infradead.org, mk7.kang@samsung.com,
        Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH 0/3] power_supply: modelgauge_battery: Add Maxim ModelGauge
 ICs gauge
References: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com> <52D565D5.4050704@samsung.com>
In-Reply-To: <52D565D5.4050704@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/14/2014 08:29 PM, Krzysztof Kozlowski wrote:
> On 01/09/2014 05:49 PM, Vladimir Barinov wrote:
>> Hello.
>>
>> This adds the folowing:
>> - Maxim ModelGauge ICs gauge driver for MAX17040/41/43/44/48/49/58/59 
>> chips
>> - Document DT bindings
>> - Remove superseded Maxim MAX17040 gauge driver
>>
>> Vladimir Barinov (3):
>>   [1/3] power_supply: modelgauge_battery: Maxim ModelGauge ICs gauge
>>   [2/3] dt: Document ModelGauge gauge bindings
>>   [3/3] power_supply: modelgauge_battery: Remove Maxim MAX17040 gauge
>
> On which tree your patchset is based on? I had conflicts when trying to
> apply this on 3.12 and 3.13.
Initially I've prepared them against 
git://git.infradead.org/battery-2.6.git master branch.
I've verified that it also applies against 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git.

For the next try I will refresh patches against the latest version of 
above trees.

> Best regards,
> Krzysztof
>
Regards,
Vladimir

