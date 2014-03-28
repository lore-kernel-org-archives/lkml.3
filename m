Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaC1PbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:31:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17152 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaC1PbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:31:06 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-4b-533595b8ca2d
Message-id: <533595B7.2090205@samsung.com>
Date: Fri, 28 Mar 2014 16:31:03 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH/RFC 8/8] DT: Add documentation for exynos4-is camera-flash
 property
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-9-git-send-email-j.anaszewski@samsung.com>
 <20140324010534.GA2847@valkosipuli.retiisi.org.uk>
In-reply-to: <20140324010534.GA2847@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xa7o7ppoGGyzZrmNxa905Vov5R4BE
	/5uFrBbnXq1ktDjb9Ibd4vKuOWwWW9+sY7To2bCV1WLp9YtMFhOmr2WxaN17hN3i8Jt2Vosz
	+1eyOfB6rJm3htHjcl8vk8fK5V/YPA5/XcjisWlVJ5tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp
	2yVwZdxq9y9YK1/RsfgUYwPjJMkuRk4OCQETif17VjBD2GISF+6tZ+ti5OIQEljKKDGvYS4z
	hPOZUeLY/YVgVbwCWhLN/1+wgNgsAqoSe04+BrPZBAwlfr54zQRiiwpESPw5vY8Vol5Q4sfk
	e2A1IgJqEk83PWQBGcos0MAs8eLDTjaQhLBApMSLhSsYIbbtYZToOf8ZLMEpYC/xuOc+WDez
	gLXEyknbGCFseYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpec
	n7uJERI5X3cwLj1mdYhRgINRiYc3s900WIg1say4MvcQowQHs5IIb9ZEoBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQbGCEHmXRordtv+kTsstGdG3z6eKCGPuzUVctLPDiX8klUwenajrrb+2+7N
	m59LcRce6QxY98o5+Oc3Jqbn0fdv202QLNo3J3p9yecAVb8Htgs1Nl2s/fzVR67Q69PjyZ5O
	gi5znkztmW15MDjdPKhskuJ67sWbD4Yc3FTQxxOhJjHPQ7gs9AqHEktxRqKhFnNRcSIAiB+r
	LXoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 03/24/2014 02:05 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Mar 20, 2014 at 03:51:10PM +0100, Jacek Anaszewski wrote:
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> ---
>>   .../devicetree/bindings/media/samsung-fimc.txt     |    3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> index 922d6f8..88f9287 100644
>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> @@ -108,6 +108,8 @@ Image sensor nodes
>>   The sensor device nodes should be added to their control bus controller (e.g.
>>   I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
>>   using the common video interfaces bindings, defined in video-interfaces.txt.
>> +If the sensor device has a led flash device associated with it then its phandle
>> +should be assigned to the camera-flash property.
>>
>>   Example:
>>
>> @@ -125,6 +127,7 @@ Example:
>>   			clock-frequency = <24000000>;
>>   			clocks = <&camera 1>;
>>   			clock-names = "mclk";
>> +			camera-flash = <&led_flash>;
>>
>>   			port {
>>   				s5k6aa_ep: endpoint {
>
> It's indeed an interesting idea to declare the flash controller in the
> sensor's properties rather than those of the ISP. The obvious upside is that
> this way it's easy to figure out which subdev group the flash controller
> belongs to.
>
> There are a few other things to consider as well:
>
> - You can't have a flash without a sensor. I can't think of why this would
>    be a real issue, though.
>
> - Relations other than one-to-one become difficult. One flash but two
>    cameras --- think of stereo cameras.
>
> 	- One camera and two flashes. I haven't seen any but I don't think
> 	  that's unthinkable.
>
> - It's not very nice of the ISP driver to just go and parse the
>    sensor's properties.
>
> - As the property is FIMC specific, the sensor DT node now carries FIMC
>    related information.
>
> A generic solution would be preferrable as this is not a FIMC related
> problem.
>
> I have to admit that I can't think of a better solution right now than just
> putting a list of the flash device phandles to the ISP device's DT node, and
> then adding information on which sensor (numeric ID) the flash is related to
> as an array. Better ideas would be welcome.
>

One reason why the flash sub-dev is registered by the sensor is the
fact that a subdev has to be registered to make it available for use.
The second reason is that it is physically connected with the sensor on
the board via torchen/flashen traces. However it would be nice if the
flash could be available for use even if its parent sensor driver isn't 
probed.

There are also possible configurations where traces are routed through
multiplexers and in such cases the sensor-flash relation is not fixed.

I propose to introduce a "flash manager" which would maintain
all the available flashes. V4L2 Flash sub-devices could register
with it asynchronously. The flash manager could expose controls
for configuring flash-sensor relations. In specific case a flash
manager could be built upon a multiplexer device. This would suit
me very well as I am currently facing such a configuration
on another board. For time being I put gpios of a multiplexer
to the flash DT node, but it doesn't reflect board configuration,
where multiplexer is a separate device. I could try to implement
the flash manager and submit an RFC. What is your opinion, does
it make a sense?

Regards,
Jacek Anaszewski

