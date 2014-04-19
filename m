Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaDSJum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 05:50:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34100 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaDSJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 05:50:39 -0400
X-AuditID: cbfee690-b7f266d00000287c-c2-535246ec62e6
Message-id: <535246ED.4090701@samsung.com>
Date: Sat, 19 Apr 2014 18:50:37 +0900
From: Sangjung <sangjung.woo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Chanwoo Choi <cwchoi00@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, again4you@gmail.com
Subject: Re: [PATCHv3 1/8] extcon: Add resource-managed extcon register function
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
 <1397781160-744-2-git-send-email-sangjung.woo@samsung.com>
 <CAGTfZH3L-FZ4+cNHYMpuRqWSbcvEZoOYQdJzxOK8yLofFc5dVw@mail.gmail.com>
In-reply-to: <CAGTfZH3L-FZ4+cNHYMpuRqWSbcvEZoOYQdJzxOK8yLofFc5dVw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWyRsSkSPeNW1CwwbRXlhYn+/tZLK5/ec5q
	8eyotsXrF4YWl3fNYbO43biCzWLG5JdsDuweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9
	uwSujHXbT7AVzDCv6Hwzg62BsUe7i5GTQ0LARKKtfQMThC0mceHeerYuRi4OIYGljBJnGzuY
	YYq2r5rADJGYziixdfFdRgjnNaPErHlv2ECqeAW0JCa83wY2ikVAVeLMn7dgcTYBTYnPxw+C
	2aICERL3Gg+zQtQLSvyYfI8FxBYBqp9yr5MdZCizwCdGifv3etlBEsICARIHpvyE2naKUeLi
	1F1Akzg4OAWCJY5PyQSpYRYwk3jUso4ZwpaX2LzmLdipEgL72CV+rZjJBnGRgMS3yYdYQHol
	BGQlNh2Aek1S4uCKGywTGMVmIblpFpKxs5CMXcDIvIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/
	dxMjMMZO/3s2YQfjvQPWhxiTgVZOZJYSTc4HxmheSbyhsZmRhamJqbGRuaUZacJK4rxqj5KC
	hATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAKzpvdUTH/TkGItoDnpeVGm45GGVXP3VmVIbBP
	QW/5ap0EF6P0g0p6fpuZlN+XHAtve7is8YQn+0Xx3/oCLIfmlkU12rg3KtbvCTvDVbqDL/zU
	qcCHQf6TBW886LvbIWGy6r2vgZxfYwrHzclnM/wub7l30P36v5o9xxqvpG1bdTr16brA8x+V
	WIozEg21mIuKEwHuMTkixwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd03bkHBBvtPGlic7O9nsbj+5Tmr
	xbOj2havXxhaXN41h83iduMKNosZk1+yObB77Jx1l92jb8sqRo/Pm+QCmKMaGG0yUhNTUosU
	UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
	9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPWbT/BVjDDvKLzzQy2BsYe7S5GTg4JAROJ7asm
	MEPYYhIX7q1n62Lk4hASmM4osXXxXUYI5zWjxKx5b9hAqngFtCQmvN/GBGKzCKhKnPnzFizO
	JqAp8fn4QTBbVCBC4l7jYVaIekGJH5PvsYDYIkD1U+51soMMZRb4xChx/14vO0hCWCBA4sCU
	n1DbTjFKXJy6C2gSBwenQLDE8SmZIDXMAmYSj1rWMUPY8hKb17xlnsAoMAvJjllIymYhKVvA
	yLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziCn0nvYFzVYHGIUYCDUYmHN0I/KFiINbGs
	uDL3EKMEB7OSCK8NK1CINyWxsiq1KD++qDQntfgQYzIwCCYyS4km5wOTS15JvKGxiZmRpZG5
	oYWRsTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MMYc566xZA5J0GvQWZFiy3/sY9hW
	ZflUqZmi358mPA7ScZjc5O+o8s7h2yfH9csdey81mZb6JVXNv1ml0fn7q3bnsy3q9spzC068
	/TTXJLJerybePeuv0gGBRafmeif6qBbY2j+Mfy4/xefvtF1eEvff1xgv3eJQuKT/uMvX9RXb
	BOQ/91+cpMRSnJFoqMVcVJwIAEIBxjMkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo.

Thanks for your comments. I also add my opinion too.


On 04/19/2014 04:13 PM, Chanwoo Choi wrote:
> Hi Sangjung,
>
> On Fri, Apr 18, 2014 at 9:32 AM, Sangjung Woo <sangjung.woo@samsung.com> wrote:
>> Add resource-managed extcon device register function for convenience.
>> For example, if a extcon device is attached with new
>> devm_extcon_dev_register(), that extcon device is automatically
>> unregistered on driver detach.
>>
>> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
>> ---
>>   drivers/extcon/extcon-class.c |   72 +++++++++++++++++++++++++++++++++++++++++
>>   include/linux/extcon.h        |   17 ++++++++++
>>   2 files changed, 89 insertions(+)
>>
>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
>> index 7ab21aa..e177edb6 100644
>> --- a/drivers/extcon/extcon-class.c
>> +++ b/drivers/extcon/extcon-class.c
>> @@ -819,6 +819,78 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>>   }
>>   EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>>
>> +
>> +/*
>> + * Device resource management
>> + */
> This comment is un-necessary because this patchset(v3) remove 'struct
> extcon_devres'.
>
>> +static void devm_extcon_dev_release(struct device *dev, void *res)
>> +{
>> +       struct extcon_dev *devres = res;
>> +
>> +       extcon_dev_unregister(devres);
> I prefer following function call withou defining separate 'devres' variable.
> But, this casting on the first argument is only for readability.
>    extcon_dev_unregister((strcut extcon_dev *)res);
>
OK. I'll fix it.

>> +}
>> +
>> +static int devm_extcon_dev_match(struct device *dev, void *res, void *data)
>> +{
>> +       struct extcon_dev *devres = res;
>> +       struct extcon_dev *match = data;
>> +       return devres == match;
> To simplify code, I think you could change checking code as following:
>              return res == data;
Right. Simple is better than others.

>> +}
>> +
>> +/**
>> + * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
>> + * @dev:       device to allocate extcon device
>> + * @edev:      the new extcon device to register
>> + *
>> + * Managed extcon_dev_register() function. If extcon device is attached with
>> + * this function, that extcon device is automatically unregistered on driver
>> + * detach. Internally this function calls extcon_dev_register() function.
>> + * To get more information, refer that function.
>> + *
>> + * If extcon device is registered with this function and the device needs to be
>> + * unregistered separately, devm_extcon_dev_unregister() should be used.
>> + *
>> + * RETURNS:
>> + * 0 on success, negative error number on failure.
>> + */
>> +int devm_extcon_dev_register(struct device *dev, struct extcon_dev *edev)
>> +{
>> +       struct extcon_dev *devres;
> The 'devres' in this function don't mean 'device resource structure'.
> So I think it is not proper name.
> I think you should use other general name (e.g.,  'ptr' or 'res'
> instead of 'devres')
>
>> +       int ret;
>> +
>> +       devres = devres_alloc(devm_extcon_dev_release, sizeof(*devres)
> Other subsytem used double pointer to get device resource from
> devres_alloc() instead of
> single pointer.(devres is single pointer)  I can't find subsystem
> using single pointer of devm function.
> First of all, We have to analyze the correct reason using only double
> pointer instead of single pointer whether single pointer use is good
> or not.

IMO, other subsystem should return the memory pointer that is allocated 
by devres_alloc().
However, in our case, we need not do that since the pointer is used only 
in extcon core.
You can refer the way that I did to gpio subsystem (devm_gpio_request() 
in /drivers/gpio/devres.c).

>> +                       GFP_KERNEL);
>> +       if (!devres)
>> +               return -ENOMEM;
>> +
>> +       ret = extcon_dev_register(edev);
>> +       if (ret) {
>> +               devres_free(devres);
>> +               return ret;
>> +       }
>> +
>> +       devres = edev;
>> +       devres_add(dev, devres);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(devm_extcon_dev_register);
>> +
>> +/**
>> + * devm_extcon_dev_unregister() - Resource-managed extcon_dev_unregister()
>> + * @dev:       device the extcon belongs to
>> + * @edev:      the extcon device to unregister
>> + *
>> + * Unregister extcon device that is registered with devm_extcon_dev_register()
>> + * function.
>> + */
>> +void devm_extcon_dev_unregister(struct device *dev, struct extcon_dev *edev)
>> +{
>> +       WARN_ON(devres_release(dev, devm_extcon_dev_release,
>> +                       devm_extcon_dev_match, edev));
>> +}
>> +EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
>> +
>>   #ifdef CONFIG_OF
>>   /*
>>    * extcon_get_edev_by_phandle - Get the extcon device from devicetree
>> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
>> index f488145..35f3343 100644
>> --- a/include/linux/extcon.h
>> +++ b/include/linux/extcon.h
>> @@ -188,6 +188,14 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
>>   extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
>>
>>   /*
>> + * Resource-managed extcon device register function.
>> + */
>> +extern int devm_extcon_dev_register(struct device *dev,
>> +                               struct extcon_dev *edev);
>> +extern void devm_extcon_dev_unregister(struct device *dev,
>> +                               struct extcon_dev *edev);
> I prefer that this function meet indentation of function definition
> needs as following:
>
> extern int devm_extcon_dev_register(struct device *dev,
>
> struct extcon_dev *edev);
> extern void devm_extcon_dev_unregister(struct device *dev,
>
>    struct extcon_dev *edev);

I have a question about the indentation issue
since my Thunderbird email client does not show me the below line tidy.

You want me to adjust the start point of the second line
to the right after parentheses of the first line. right?

>> +
>> +/*
>>    * get/set/update_state access the 32b encoded state value, which represents
>>    * states of all possible cables of the multistate port. For example, if one
>>    * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
>> @@ -254,6 +262,15 @@ static inline int extcon_dev_register(struct extcon_dev *edev)
>>
>>   static inline void extcon_dev_unregister(struct extcon_dev *edev) { }
>>
>> +static inline devm_extcon_dev_register(struct device *dev,
>> +               struct extcon_dev *edev)
> Missing the type of return value.
> -> static inline int devm_extcon_dev_register(...
>
> Also, ditto about function definition identification.

Right. I made a mistake.
>
>> +{
>> +       return 0;
>> +}
>> +
>> +static inline devm_extcon_dev_unregister(struct device *dev,
> ditto.
> -> static inline void devm_extcon_dev_unregister(...
>
> Thanks,
> Chanwoo Choi
>

