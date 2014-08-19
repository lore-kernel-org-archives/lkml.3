Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaHSXrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 19:47:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51307 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHSXrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 19:47:35 -0400
X-AuditID: cbfee691-b7f306d000003d81-09-53f3e21483bb
Message-id: <53F3E214.4000409@samsung.com>
Date: Wed, 20 Aug 2014 08:47:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: "edubezval@gmail.com" <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Amit Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, l.majewski@samsung.com,
        naveen krishna <ch.naveen@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] thermal: exynos: Add support for TRIM_RELOAD feature at
 Exynos3250
References: <1408449463-3987-1-git-send-email-cw00.choi@samsung.com>
 <1408450078-6296-1-git-send-email-cw00.choi@samsung.com>
 <CAC-25o9ExZVTczq3ttkc5XX9ozXUCby2m7hAkUe=LAQakjzVWA@mail.gmail.com>
In-reply-to: <CAC-25o9ExZVTczq3ttkc5XX9ozXUCby2m7hAkUe=LAQakjzVWA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkUFfk0edgg7X/jC0aroZYbJyxntXi
	7vPDjBbzj5xjtViz/yeTxfwr11gtehdcZbM42/SG3eLNw82MFpseA8Uu75rDZvG59wijxYzz
	+5gsnjzsY7NYP+M1iwO/x85Zd9k9Fu95yeSxeUm9R9+WVYwex29sZ/L4vEkugC2KyyYlNSez
	LLVI3y6BK2PTxRcsBe8MKnpvhjQwLlHtYuTkkBAwkVi8ZiU7hC0mceHeerYuRi4OIYGljBKv
	/v9mhSn63reJHSIxnVFi7pInUM5rRomnf5cyg1TxCmhJ9O4/wgZiswioSqyZ9YkFxGYDiu9/
	cQMsLioQJrFy+hUWiHpBiR+T74HZIgL6Eo+aXjCCDGUWWMYq0bD8CdhQYYFoiX3HnjBCbDvG
	KLFu6Q+wYzkFgiUevbgBVsQsoC4xad4iKFteYvOat8wgDRICrRwSHX8fQp0kIPFt8iGgdRxA
	CVmJTQeYIX6TlDi44gbLBEaxWUiOmoVk7CwkYxcwMq9iFE0tSC4oTkovMtUrTswtLs1L10vO
	z93ECIzo0/+eTdzBeP+A9SHGZKCVE5mlRJPzgQkhryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJ
	QUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYzzDbWodbrzp5dfLF2zkNhae2W7ht8pGaUv7T
	Vzp7x3e1yJfZMk8SlDZESdfL2fi/X7TKm8nmSPjRtMZFffYHhBfwKN/9aN902Xlnz4aDjby7
	w7YbfFjmKjR9hcT/eSGsZrFnEj1EVhfuF1TtuK+zt6bZ+NpWd6GT73L7xLYvu3j4dqS11GQP
	JZbijERDLeai4kQA+GR1ZP4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQV2RR5+DDY5817RouBpisXHGelaL
	u88PM1rMP3KO1WLN/p9MFvOvXGO16F1wlc3ibNMbdos3DzczWmx6DBS7vGsOm8Xn3iOMFjPO
	72OyePKwj81i/YzXLA78Hjtn3WX3WLznJZPH5iX1Hn1bVjF6HL+xncnj8ya5ALaoBkabjNTE
	lNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCTlRTKEnNKgUIB
	icXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZmy6+YCl4Z1DRezOkgXGJahcjJ4eEgInE
	975N7BC2mMSFe+vZuhi5OIQEpjNKzF3yhB3Cec0o8fTvUmaQKl4BLYne/UfYQGwWAVWJNbM+
	sYDYbEDx/S9ugMVFBcIkVk6/wgJRLyjxY/I9MFtEQF/iUdMLRpChzALLWCUalj8BGyosEC2x
	79gTRohtxxgl1i39AXYTp0CwxKMXN8CKmAXUJSbNWwRly0tsXvOWeQKjwCwkS2YhKZuFpGwB
	I/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOB08Ux6B+OqBotDjAIcjEo8vA7tn4OFWBPL
	iitzDzFKcDArifCydgCFeFMSK6tSi/Lji0pzUosPMZoCw2Ais5Rocj4wleWVxBsam5gZWRqZ
	G1oYGZsrifMebLUOFBJITyxJzU5NLUgtgulj4uCUamBcJpwqHJM0qYwv3+m9vOysfQ/Yl9a7
	Vzaozp97dKY7n10aWxm/xcXnn5y1bS35vxwr6W3xb9S9LcxeeXlN0o2t4b737suocVpnM22/
	9/rckWpncc8/m09djfR6vY1X4L2aeM6G+9JXLTeU1nrX8d40YHZczN27Mv4Lly9TivKC0t59
	bySllZRYijMSDbWYi4oTAWNJVIotAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eduardo,

I'm so sorry. This patch has build break as following:
It is my mistake about missing 'or' operation when adding TMU_SUPPORT_TRIM_RELOAD.

+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD\

I'll send new patch to fix it right now.

Best Regards,
Chanwoo Choi

On 08/19/2014 09:28 PM, edubezval@gmail.com wrote:
> Amit,
> 
> On Tue, Aug 19, 2014 at 8:07 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch add support for TRIM_RELOAD feature at Exynos3250. The TMU of
>> Exynos3250 has two TRIMINFO_CON register.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Eduardo Valentin <edubezval@gmail.com>
> 
> What do you think about this patch?
> 
>> ---
>> Changes from v1:
>> - Add missing 'TMU_SUPPORT_TRIM_RELOAD' features
>>
>>  drivers/thermal/samsung/exynos_tmu.c      |  7 +++++--
>>  drivers/thermal/samsung/exynos_tmu.h      |  5 +++--
>>  drivers/thermal/samsung/exynos_tmu_data.c | 11 +++++++++--
>>  drivers/thermal/samsung/exynos_tmu_data.h |  7 +++++--
>>  4 files changed, 22 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index acbff14..ed01606 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -164,8 +164,11 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>>                 }
>>         }
>>
>> -       if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
>> -               __raw_writel(1, data->base + reg->triminfo_ctrl);
>> +       if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
>> +               for (i = 0; i < pdata->triminfo_reload_count; i++)
>> +                       __raw_writel(pdata->triminfo_reload[i],
>> +                                       data->base + reg->triminfo_ctrl[i]);
>> +       }
>>
>>         if (pdata->cal_mode == HW_MODE)
>>                 goto skip_calib_data;
>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
>> index 1b4a644..72cb54e 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -151,8 +151,7 @@ struct exynos_tmu_registers {
>>         u32     triminfo_25_shift;
>>         u32     triminfo_85_shift;
>>
>> -       u32     triminfo_ctrl;
>> -       u32     triminfo_ctrl1;
>> +       u32     triminfo_ctrl[2];
>>         u32     triminfo_reload_shift;
>>
>>         u32     tmu_ctrl;
>> @@ -295,6 +294,8 @@ struct exynos_tmu_platform_data {
>>         u8 second_point_trim;
>>         u8 default_temp_offset;
>>         u8 test_mux;
>> +       u8 triminfo_reload[2];
>> +       u8 triminfo_reload_count;
>>
>>         enum calibration_type cal_type;
>>         enum calibration_mode cal_mode;
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>> index aa8e0de..b45aa90 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>> @@ -95,6 +95,8 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
>>         .triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
>>         .triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
>>         .triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
>> +       .triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
>> +       .triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
>>         .tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
>>         .test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
>>         .buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
>> @@ -160,8 +162,11 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
>>                 .temp_level = 95, \
>>         }, \
>>         .freq_tab_count = 2, \
>> +       .triminfo_reload[0] = 0x1, \
>> +       .triminfo_reload[1] = 0x11, \
>> +       .triminfo_reload_count = 2, \
>>         .registers = &exynos3250_tmu_registers, \
>> -       .features = (TMU_SUPPORT_EMULATION | \
>> +       .features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD\
>>                         TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
>>                         TMU_SUPPORT_EMUL_TIME)
>>  #endif
>> @@ -184,7 +189,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>>         .triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
>>         .triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
>>         .triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
>> -       .triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
>> +       .triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
>>         .triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
>>         .tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
>>         .test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
>> @@ -252,6 +257,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>>                 .temp_level = 95, \
>>         }, \
>>         .freq_tab_count = 2, \
>> +       .triminfo_reload[0] = 0x1, \
>> +       .triminfo_reload_count = 1, \
>>         .registers = &exynos4412_tmu_registers, \
>>         .features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
>>                         TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>> index f0979e5..e0536c3 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>> @@ -57,8 +57,11 @@
>>  #define EXYNOS4210_TMU_TRIG_LEVEL_MASK 0x1111
>>  #define EXYNOS4210_TMU_INTCLEAR_VAL    0x1111
>>
>> -/* Exynos5250 and Exynos4412 specific registers */
>> -#define EXYNOS_TMU_TRIMINFO_CON        0x14
>> +/* Exynos3250 specific registers */
>> +#define EXYNOS_TMU_TRIMINFO_CON1       0x10
>> +
>> +/* Exynos5250, Exynos4412 and Exynos3250 specific registers */
>> +#define EXYNOS_TMU_TRIMINFO_CON2       0x14
>>  #define EXYNOS_THD_TEMP_RISE           0x50
>>  #define EXYNOS_THD_TEMP_FALL           0x54
>>  #define EXYNOS_EMUL_CON                0x80
>> --
>> 1.8.0
>>
> 
> 
> 

