Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaLIOCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:02:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16941 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaLIOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:02:10 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-02-548700e007f3
Message-id: <548700DE.2050208@samsung.com>
Date: Tue, 09 Dec 2014 15:02:06 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 04/19] mfd: max77693: adjust
 max77693_led_platform_data
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-5-git-send-email-j.anaszewski@samsung.com>
 <20141209085047.GR3951@x1> <5486BC44.7010602@samsung.com>
 <20141209100413.GW3951@x1> <5486CE1F.9010102@samsung.com>
 <20141209135017.GY3951@x1>
In-reply-to: <20141209135017.GY3951@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4Nd0HDO0hBve3y1hsnLGe1eLozolM
	Fte/PGe16H+zkNXi3KuVjBZnm96wW9z/epTR4vKuOWwWW9+sY7To2bCV1WLp9YtMFndPHWWz
	mDB9LYtF694j7Ba7dz1ltTj8pp3V4sz+lWwOgh5r5q1h9Ljc18vksXPWXXaPlcu/sHkc/rqQ
	xWPTqk42jzvX9rB57Jn/g9Wjb8sqRo8Vq7+ze3zeJBfAHcVlk5Kak1mWWqRvl8CVsfvwTbaC
	31IVJ/YdZWtg/CbaxcjJISFgIvGm7yMThC0mceHeerYuRi4OIYGljBIPf/6Acj4ySmzfvZsd
	pIpXQEviz745rCA2i4CqxOQzt8DibAKGEj9fvAabJCoQIfHn9D5WiHpBiR+T77F0MXJwiAio
	SJx7Yw4yk1lgMrPE0Xtr2EBqhAVCJDY8m88MYgsJzGGS+NQdBlLPKaAuMWeLK0iYWcBM4lHL
	OmYIW15i85q3zBMYBWYh2TALSdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoRE
	4dcdjEuPWR1iFOBgVOLh3aHYFiLEmlhWXJl7iFGCg1lJhHfKUaAQb0piZVVqUX58UWlOavEh
	RiYOTqkGxrMTJj7mSnZRTWO+V9QX+zaraWJB/uG5b/Oa/9f9WG4+I77lRtpuaSn2l5nXo5bM
	KJ3p9jbwt6Xllof7WqamLfvVt1Ignqf9te006xVRy0/IcnJeTZ71/+eyjZ+mLu6+W5bkIvFh
	77LyeP8jx0Ke+2nfmf4yIIhB980r4cub2vsXa+6tPdD9bKoSS3FGoqEWc1FxIgApY2DIoAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 02:50 PM, Lee Jones wrote:
> On Tue, 09 Dec 2014, Jacek Anaszewski wrote:
>
>> On 12/09/2014 11:04 AM, Lee Jones wrote:
>>> On Tue, 09 Dec 2014, Jacek Anaszewski wrote:
>>>
>>>> On 12/09/2014 09:50 AM, Lee Jones wrote:
>>>>> On Wed, 03 Dec 2014, Jacek Anaszewski wrote:
>>>>>
>>>>>> Add "label" array for Device Tree strings with the name of a LED device
>>>>>> and make flash_timeout a two element array, for caching the sub-led
>>>>>> related flash timeout. Added is also an array for caching pointers to the
>>>>>> sub-nodes representing sub-leds.
>>>>>>
>>>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>>>>>> Cc: Lee Jones <lee.jones@linaro.org>
>>>>>> ---
>>>>>>   include/linux/mfd/max77693.h |    4 +++-
>>>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
>>>>>> index f0b6585..c80ee99 100644
>>>>>> --- a/include/linux/mfd/max77693.h
>>>>>> +++ b/include/linux/mfd/max77693.h
>>>>>> @@ -88,16 +88,18 @@ enum max77693_led_boost_mode {
>>>>>>   };
>>>>>>
>>>>>>   struct max77693_led_platform_data {
>>>>>> +	const char *label[2];
>>>>>>   	u32 fleds[2];
>>>>>>   	u32 iout_torch[2];for_each_available_child_of_node
>>>>>>   	u32 iout_flash[2];
>>>>>>   	u32 trigger[2];
>>>>>>   	u32 trigger_type[2];
>>>>>> +	u32 flash_timeout[2];
>>>>>>   	u32 num_leds;
>>>>>>   	u32 boost_mode;
>>>>>> -	u32 flash_timeout;
>>>>>>   	u32 boost_vout;
>>>>>>   	u32 low_vsys;
>>>>>> +	struct device_node *sub_nodes[2];
>>>>>
>>>>> I haven't seen anyone do this before.  Why can't you use the provided
>>>>> OF functions to traverse through your tree?
>>>>
>>>> I use for_each_available_child_of_node when parsing DT node, but I
>>>> need to cache the pointer to sub-node to be able to use it later
>>>> when it needs to be passed to V4L2 sub-device which is then
>>>> asynchronously matched by the phandle to sub-node.
>>>>
>>>> If it is not well seen to cache it in the platform data then
>>>> I will find different way to accomplish this.
>>>
>>> I haven't seen the end-driver for this, but why can't you use that
>>> device's of_node pointer?
>>
>> Maybe it is indeed a good idea. I could pass the of_node pointer
>> and the sub-led identifier to the V4L2 sub-device and there look
>> for the sub-node containing relevant identifier. The downside
>> would be only that for_each_available_child_of_node would
>> have to be called twice - in the led driver and in the V4L2 sub-device.
>> I think that we can live with it.
>
> Are the LED and V4L2 drivers children of this MFD?  If so, you can use
> the of_compatible attribute in struct mfd_cell to populate the each
> child's of_node dynamically i.e. the MFD core will do that for you.
>

V4L2 driver wraps LED driver. This way the LED device can be
controlled with use of two interfaces - LED subsystem sysfs
and V4L2 Flash. This is the aim of the whole patch set.

I've thought it over again and it seems that I will need to cache
somewhere these sub_nodes pointers. They have to be easily accessible
for the V4L2 sub-device as it can be asynchronously registered
or unregistered within V4L2 media device. Sub-devices are matched
basing on the sub-node phandle.

Best Regards,
Jacek Anaszewski
