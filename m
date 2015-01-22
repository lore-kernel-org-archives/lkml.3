Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbbAVIrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:47:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58822 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVIrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:47:05 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-3b-54c0b87574a8
Message-id: <54C0B905.3010002@samsung.com>
Date: Thu, 22 Jan 2015 09:47:01 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH/RFC v10 17/19] DT: Add documentation for exynos4-is
 'flashes' property
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-18-git-send-email-j.anaszewski@samsung.com>
 <54BFD4B9.8030707@samsung.com>
In-reply-to: <54BFD4B9.8030707@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e/4Nd3SHQdCDLauU7HYOGM9q8XRnROZ
	LOYfOcdq0f9mIavFuVcrGS3ONr1ht7i8aw6bxdY36xgtejZsZbVYev0ik8XdU0fZLCZMX8ti
	0br3CLvF7l1PWS0Ov2lntTizfyWbg4DHmnlrGD0u9/UyeeycdZfdY+XyL2weh78uZPHYtKqT
	zWPP/B+sHn1bVjF6rFj9nd3j8ya5AK4oLpuU1JzMstQifbsErozLm/8wFszhq+h7t5ulgfEe
	dxcjJ4eEgInE/79nmSBsMYkL99azdTFycQgJLGWU2LJ1NjOE85FRomn9KrAqXgEtiXON84Fs
	Dg4WAVWJzw/UQcJsAoYSP1+8BisRFYiQ+HN6HytEuaDEj8n3WEBsEQF9iSWrLoItYBbYySyx
	/tIdRpA5wgIxEoufuYDUCAksZ5T40+APYnMKaEs0zH7GBmIzC9hKLHi/jgXClpfYvOYt8wRG
	gVlIVsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCER93UH49JjVocYBTgY
	lXh4IzYcCBFiTSwrrsw9xCjBwawkwrsTJMSbklhZlVqUH19UmpNafIiRiYNTqoFxo0vwrcXz
	DnyWvH3j+fKHDs9TY/o5iyPL98T7rL577F5ulPJK7VWTJWt0pyt8lWG0lbnZkfhfa4Uph+rt
	6bsnvklUOHuQo/T1u8l5r4qWputKmqTl3MrUjjrFtVJRl/2LssXsGeyTLr779+HIpzcejH7i
	i/IPH751gitp2TZLBRH9R4Ip8/neKbEUZyQaajEXFScCAB6o9HWWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/21/2015 05:32 PM, Sylwester Nawrocki wrote:
> Hi,
>
> On 09/01/15 16:23, Jacek Anaszewski wrote:
>> This patch adds a description of 'flashes' property
>> to the samsung-fimc.txt.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>
>> ---
>>   .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> index 922d6f8..22a6b2f 100644
>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> @@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
>>   and the port B deactivated and for the state "active-b" it should be the other
>>   way around.
>>
>> +Optional properties:
>> +
>> +- flashes - Array of phandles to flash LED devices, or their sub-nodes
>> +	    representing sub-leds.
>> +	    (see Documentation/devicetree/bindings/leds/common.txt)
>
> How about renaming this to "illuminators" or something else more generic?
> The "torch" LED (for video recording illumination?) is not really a flash.

OK, currently I can't think of a better substitute for 'illuminators'.

Since it has been agreed that a discrete LED component requires a child
node in a LED device binding, even if there is only one current output
exposed by the LED device, this description has to be modified as follows:

- illuminators - Array of phandles to the child nodes of a flash LED
	device related binding.
	(see Documentation/devicetree/bindings/leds/common.txt).


-- 
Best Regards,
Jacek Anaszewski
