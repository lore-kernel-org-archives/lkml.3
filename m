Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaEZHPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:15:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61273 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaEZHPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:15:45 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-db-5382ea1f6350
Message-id: <5382EA1E.8060202@samsung.com>
Date: Mon, 26 May 2014 16:15:42 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Ball <chris@printf.net>
Subject: Re: [PATCH RFC] mmc: add slot argument to mmc_of_parse
References: <1399457217-22846-1-git-send-email-ludovic.desroches@atmel.com>
 <CAPDyKFqeunnWmguTH89byNc5Yy+CBY4avMeeon3ZSfNMmGJa9Q@mail.gmail.com>
 <537ED0AE.7040901@samsung.com>
 <20140526070301.GA12777@ldesroches-Latitude-E6320>
In-reply-to: <20140526070301.GA12777@ldesroches-Latitude-E6320>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWyRsSkQFf+VVOwwaXd0hYTLm9ntNj0+Bqr
	xeVdc9gsjvzvZ7Q4vjbcgdXjzrU9bB6bl9R73Hi1kMnj8ya5AJYoLpuU1JzMstQifbsErozV
	f/QLLipVPDt+l6mBsUO6i5GTQ0LARGLCihtsELaYxIV764FsLg4hgaWMErf33WCFKdrTMYsJ
	xBYSmM4ocWQBJ0TRa0aJVS2tYN28AloSNz98BGtgEVCV+LFyLjOIzSagI7H923GwZlGBMImn
	m/9A1QtK/Jh8jwVkkIhAC5PEls/P2UESwgL2EtMWLGCB2PCCUaLv9SawDk6gxOUbv8CmMgNN
	3d86jQ3ClpfYvOYtM0iDhMAydokfU46zQ5whIPFt8iGgSRxACVmJTQeYId6RlDi44gbLBEbR
	WUgOmYVk7CwkYxcwMq9iFE0tSC4oTkovMtUrTswtLs1L10vOz93ECIyf0/+eTdzBeP+A9SHG
	ZKCVE5mlRJPzgfGXVxJvaGxmZGFqYmpsZG5pRpqwkjhv+qOkICGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2M+p4H/puvfzVBKfb3rEWfigruaatYOv4TPW6gtvuQ97EnLH++LO5vj5qgnzRN
	8GzqgocfjGpdze8I3cmPWGl8oWOiiEDPX8vy/7J630vn/ZnLIfThoWnU9WPStz8FRZpsYQh2
	XvpVJW9tMVvvJtsZpV5f56V11KcvSWXJlLuRrn4rfUKvPfNSJZbijERDLeai4kQAmFVBvrUC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jQV35V03BBs/+CVlMuLyd0WLT42us
	Fpd3zWGzOPK/n9Hi+NpwB1aPO9f2sHlsXlLvcePVQiaPz5vkAliiGhhtMlITU1KLFFLzkvNT
	MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJaxgzVv/RL7ioVPHs+F2mBsYO6S5GTg4JAROJPR2zmCBsMYkL
	99azgdhCAtMZJY4s4Oxi5AKyXzNKrGppBUvwCmhJ3PzwkRXEZhFQlfixci4ziM0moCOx/dtx
	sEGiAmESTzf/gaoXlPgx+R4LyCARgRYmiS2fn7ODJIQF7CWmLVjAArHhBaNE3+tNYB2cQInL
	N36BTWUGmrq/dRobhC0vsXnNW+YJjPyzkAyehaRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL
	89L1kvNzNzGCo/OZ9A7GVQ0WhxgFOBiVeHgPeDcFC7EmlhVX5h5ilOBgVhLhvZALFOJNSays
	Si3Kjy8qzUktPsSYDPT3RGYp0eR8YOLIK4k3NDYxM7I0Mje0MDI2J01YSZz3YKt1oJBAemJJ
	anZqakFqEcwWJg5OqQZG752XtrFyJvOs/6Vat2OBeKFa2TemrepXOJ9tfy9ezJS4XeXdmyMS
	BXt7f27WVXFji+tnnOX3qYjF/W+xXcTmuL2H6g9XvXnt33Zpe8D9eINlyrwbbIQCKjuO1a6e
	33rX+uGZy1KBkluCJD+fSZq+U5GzTrzpwKz0j+u3aO3lF7mR3L712qqTSizFGYmGWsxFxYkA
	8+9yMhIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ludovic.

I have sent the patch based on your RFC patch..how about?
If you have the comment or other opinion, let me know, plz.

https://patchwork.kernel.org/patch/4230101/

It needs to use your suggestion at dw-mmc controller, so i have posted it.

Best Regards,
Jaehoon Chung

On 05/26/2014 04:03 PM, Ludovic Desroches wrote:
> Hi,
> 
> Sorry I was on vacation, I'll send a cleaner patch updating other drivers
> this week.
> 
> Regards
> 
> Ludovic
> 
> On Fri, May 23, 2014 at 01:38:06PM +0900, Jaehoon Chung wrote:
>> Hi, All.
>>
>> This patch is working on progress?
>> I want to merge this patch for fixing dw-mmc controller problem.
>>
>> If this patch didn't work on progress, i will send the patch based-on this patch.
>>
>> Best Regards,
>> Jaehoon Chung
>>
>> On 05/14/2014 06:53 PM, Ulf Hansson wrote:
>>> On 7 May 2014 12:06, Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
>>>> Some hosts manage several slots. In these case information such as the bus
>>>> width, chip detect and others are into the slot node. So we have to parse
>>>> child nodes. If not NULL, slot node will be used instead of the device
>>>> node.
>>>>
>>>> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>>>> ---
>>>>
>>>> Hi,
>>>>
>>>> Since this patch is only a RFC, I have not yet updated drivers using this
>>>> function.
>>>>
>>>> I would like to use mmc_of_parse to reduce code duplication. My issue is that
>>>> atmel mci is a bit different from others mci host since it can provide
>>>> several slots, so it allocates several mmc hosts. By the way, it is not the
>>>> only one.
>>>>
>>>> When calling mmc_alloc_host, host->parent is set to &pdev->dev. mmc_of_parse
>>>> uses host->parent->of_node but in my case settings are in the slot nodes so in
>>>> the child nodes. That's why I would like to have a way to tell which node I
>>>> want to use.
>>>
>>> Seems reasonable, thanks for working on this!
>>>
>>>>
>>>>
>>>> Regards
>>>>
>>>> Ludovic
>>>>
>>>>
>>>>
>>>>  drivers/mmc/core/host.c |    9 +++++++--
>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
>>>> index fdea825..ed6cea5 100644
>>>> --- a/drivers/mmc/core/host.c
>>>> +++ b/drivers/mmc/core/host.c
>>>> @@ -300,13 +300,15 @@ static inline void mmc_host_clk_sysfs_init(struct mmc_host *host)
>>>>  /**
>>>>   *     mmc_of_parse() - parse host's device-tree node
>>>>   *     @host: host whose node should be parsed.
>>>> + *     @slot: some devices provide several slots so the node to parse
>>>> + *     is not the host one.
>>>>   *
>>>>   * To keep the rest of the MMC subsystem unaware of whether DT has been
>>>>   * used to to instantiate and configure this host instance or not, we
>>>>   * parse the properties and set respective generic mmc-host flags and
>>>>   * parameters.
>>>>   */
>>>> -int mmc_of_parse(struct mmc_host *host)
>>>> +int mmc_of_parse(struct mmc_host *host, struct device_node *slot)
>>>>  {
>>>>         struct device_node *np;
>>>>         u32 bus_width;
>>>> @@ -317,7 +319,10 @@ int mmc_of_parse(struct mmc_host *host)
>>>>         if (!host->parent || !host->parent->of_node)
>>>>                 return 0;
>>>>
>>>> -       np = host->parent->of_node;
>>>> +       if (slot)
>>>> +               np = slot;
>>>> +       else
>>>> +               np = host->parent->of_node;
>>>>
>>>>         /* "bus-width" is translated to MMC_CAP_*_BIT_DATA flags */
>>>>         if (of_property_read_u32(np, "bus-width", &bus_width) < 0) {
>>>> --
>>>> 1.7.9.5
>>>>
>>>
>>> How about adding a new API, __mmc_of_parse((struct mmc_host *host,
>>> struct device_node *slot)
>>> Then let the old API mmc_of_parse() remain as is, but let it call the
>>> new API with slot == NULL.
>>>
>>> Atmel can then use the new API, but the other drivers can remain as is.
>>>
>>> Kind regards
>>> Ulf Hansson
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

