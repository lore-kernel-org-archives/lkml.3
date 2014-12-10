Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaLJMjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:39:01 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47007 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaLJMi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:38:59 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f2-54883ee1a30a
Message-id: <54883EDF.2040304@samsung.com>
Date: Wed, 10 Dec 2014 13:38:55 +0100
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
 <20141209135017.GY3951@x1> <548700DE.2050208@samsung.com>
 <20141209144100.GA3951@x1>
In-reply-to: <20141209144100.GA3951@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Zd2Hdh0hBv1v+C02zljPanF050Qm
	i+tfnrNa9L9ZyGpx7tVKRouzTW/YLe5/PcpocXnXHDaLrW/WMVr0bNjKarH0+kUmi7unjrJZ
	TJi+lsWide8Rdovdu56yWhx+085qcWb/SjYHQY8189Ywelzu62Xy2DnrLrvHyuVf2DwOf13I
	4rFpVSebx51re9g89sz/werRt2UVo8eK1d/ZPT5vkgvgjuKySUnNySxLLdK3S+DKeLHpM0vB
	FfmKH0/+MDYwfpDsYuTgkBAwkXjcnNDFyAlkiklcuLeerYuRi0NIYCmjxJwV+9ghnI+MEncv
	PmcBqeIV0JLYeWgOmM0ioCqx9tcmVhCbTcBQ4ueL10wgtqhAhMSf0/tYIeoFJX5MvscCskxE
	QEXi3BtzkJnMApOZJY7eW8MGUiMsECKx4dl8ZohlN5gkfl+7DtbMKaAu8XviMnYQm1nATOJR
	yzpmCFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKE
	xOHXHYxLj1kdYhTgYFTi4d2h2BYixJpYVlyZe4hRgoNZSYT3jWRHiBBvSmJlVWpRfnxRaU5q
	8SFGJg5OqQbGG1N5Z6su//iw/I6Yw2em7po3nGVXw3TcJ5/9/dZ9/ZqTM+dnrQ18nfLfNUlF
	5sr+RFF/4+BWj2eHc5iFDxQlBzaeVFj9PWNLzwujt6tZmOZt2Z9vtdrQqPlBibrp3OcKDA/f
	Fn98WPJIY3pMXXft3phb9qmxLsy2cy8tnm/H/f35xvPRCn9eKLEUZyQaajEXFScCAJ7LiAWh	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 03:41 PM, Lee Jones wrote:
> On Tue, 09 Dec 2014, Jacek Anaszewski wrote:
>
>> On 12/09/2014 02:50 PM, Lee Jones wrote:
>>> On Tue, 09 Dec 2014, Jacek Anaszewski wrote:
>>>
>>>> On 12/09/2014 11:04 AM, Lee Jones wrote:
>>>>> On Tue, 09 Dec 2014, Jacek Anaszewski wrote:
>>>>>
>>>>>> On 12/09/2014 09:50 AM, Lee Jones wrote:
>>>>>>> On Wed, 03 Dec 2014, Jacek Anaszewski wrote:
>>>>>>>
>>>>>>>> Add "label" array for Device Tree strings with the name of a LED device
>>>>>>>> and make flash_timeout a two element array, for caching the sub-led
>>>>>>>> related flash timeout. Added is also an array for caching pointers to the
>>>>>>>> sub-nodes representing sub-leds.
>>>>>>>>
>>>>>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>>>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>>>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>>>>>>>> Cc: Lee Jones <lee.jones@linaro.org>
>>>>>>>> ---
>>>>>>>>   include/linux/mfd/max77693.h |    4 +++-
>>>>>>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
>>>>>>>> index f0b6585..c80ee99 100644
>>>>>>>> --- a/include/linux/mfd/max77693.h
>>>>>>>> +++ b/include/linux/mfd/max77693.h
>>>>>>>> @@ -88,16 +88,18 @@ enum max77693_led_boost_mode {
>>>>>>>>   };
>>>>>>>>
>>>>>>>>   struct max77693_led_platform_data {
>>>>>>>> +	const char *label[2];
>>>>>>>>   	u32 fleds[2];
>>>>>>>>   	u32 iout_torch[2];for_each_available_child_of_node
>>>>>>>>   	u32 iout_flash[2];
>>>>>>>>   	u32 trigger[2];
>>>>>>>>   	u32 trigger_type[2];
>>>>>>>> +	u32 flash_timeout[2];
>>>>>>>>   	u32 num_leds;
>>>>>>>>   	u32 boost_mode;
>>>>>>>> -	u32 flash_timeout;
>>>>>>>>   	u32 boost_vout;
>>>>>>>>   	u32 low_vsys;
>>>>>>>> +	struct device_node *sub_nodes[2];
>>>>>>>
>>>>>>> I haven't seen anyone do this before.  Why can't you use the provided
>>>>>>> OF functions to traverse through your tree?
>>>>>>
>>>>>> I use for_each_available_child_of_node when parsing DT node, but I
>>>>>> need to cache the pointer to sub-node to be able to use it later
>>>>>> when it needs to be passed to V4L2 sub-device which is then
>>>>>> asynchronously matched by the phandle to sub-node.
>>>>>>
>>>>>> If it is not well seen to cache it in the platform data then
>>>>>> I will find different way to accomplish this.
>>>>>
>>>>> I haven't seen the end-driver for this, but why can't you use that
>>>>> device's of_node pointer?
>>>>
>>>> Maybe it is indeed a good idea. I could pass the of_node pointer
>>>> and the sub-led identifier to the V4L2 sub-device and there look
>>>> for the sub-node containing relevant identifier. The downside
>>>> would be only that for_each_available_child_of_node would
>>>> have to be called twice - in the led driver and in the V4L2 sub-device.
>>>> I think that we can live with it.
>>>
>>> Are the LED and V4L2 drivers children of this MFD?  If so, you can use
>>> the of_compatible attribute in struct mfd_cell to populate the each
>>> child's of_node dynamically i.e. the MFD core will do that for you.
>>>
>>
>> V4L2 driver wraps LED driver. This way the LED device can be
>> controlled with use of two interfaces - LED subsystem sysfs
>> and V4L2 Flash. This is the aim of the whole patch set.
>>
>> I've thought it over again and it seems that I will need to cache
>> somewhere these sub_nodes pointers. They have to be easily accessible
>> for the V4L2 sub-device as it can be asynchronously registered
>> or unregistered within V4L2 media device. Sub-devices are matched
>> basing on the sub-node phandle.
>
> Not quite getting this.  Can you explain this in another way please?
>

It turned out that it is possible to store the sub-node pointer in the
struct device returned by device_create_with_groups, while creating LED
class device. Its of_node property is uninitialized.
Regardless of it - there will be next version of this patch.

Best Regards,
Jacek Anaszewski
