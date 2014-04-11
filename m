Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaDKEqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 00:46:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12539 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaDKEqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 00:46:51 -0400
X-AuditID: cbfee68f-b7f156d00000276c-95-534773b935d8
Message-id: <534773BB.5060800@samsung.com>
Date: Fri, 11 Apr 2014 13:46:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 10/27] ARM: dts: exynos3250: Add new exynos3250.dtsi file
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
 <1397124377-16969-2-git-send-email-cw00.choi@samsung.com>
 <CAK9yfHzWvddP_A_Vta3kzS4q0=dU3LJwWRu_CwCwsHJSfieihQ@mail.gmail.com>
In-reply-to: <CAK9yfHzWvddP_A_Vta3kzS4q0=dU3LJwWRu_CwCwsHJSfieihQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkWHdnsXuwQcMhXYvPH1rYLSbdn8Bi
	0bvgKpvF2aY37BabHl9jtbi8aw6bxYzz+5gsTv7pZbSYMfklm8X6Ga9ZLPbunMzowO1x59oe
	No/NS+o9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2PH3slsBe8EK56uu8PawPiKt4uRk0NC
	wERi8eTDTBC2mMSFe+vZuhi5OIQEljJKPNgwjbGLkQOsaEqXI0R8EaPE5g1XmCCc14wSv67v
	AuvmFdCS+LT2EhuIzSKgKnFy1SoWEJsNKL7/xQ2wuKhAmMTK6VdYIOoFJX5MvgdmiwDVvOxe
	DjaUWaCLWeLxmYlgCWEBX4nGxcuYIbadYJR48WMrO8hJnALBEi//g73ALKAjsb91GhuELS+x
	ec1bsHoJgZfsEstfH2CFuEhA4tvkQywQ78hKbDrADPGypMTBFTdYJjCKzUJy0ywkY2chGbuA
	kXkVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmBUnv73rH8H490D1ocYk4FWTmSWEk3OB0Z1
	Xkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgLF+/
	YyVXwxrJaJ9n5QxPFxz7/mGOfUhg09XbTDNE5b8IpBxlXhku+PTkARaORZ0/rdPPPmdRuPlz
	lv6XM3ssXq37ObVR99dsXuOqQLb58z7l6JnPn798tbmLGf81bcuqAI5Iuew5W2x2pP7TaWKx
	C1cIe7tbokGhrvLuOe+Fhdk2zy90961arcRSnJFoqMVcVJwIAIqcV8XgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd2dxe7BBlMeqFh8/tDCbjHp/gQW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfJPL6PFjMkv2SzWz3jNYrF352RGB26PO9f2
	sHlsXlLv0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	duydzFbwTrDi6bo7rA2Mr3i7GDk4JARMJKZ0OXYxcgKZYhIX7q1n62Lk4hASWMQosXnDFSYI
	5zWjxK/ru5hAqngFtCQ+rb3EBmKzCKhKnFy1igXEZgOK739xAywuKhAmsXL6FRaIekGJH5Pv
	gdkiQDUvu5eDDWUW6GKWeHxmIlhCWMBXonHxMmaIbScYJV782MoOch6nQLDEy/+8IDXMAjoS
	+1unsUHY8hKb17xlnsAoMAvJjllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cT
	Izjmn0nvYFzVYHGIUYCDUYmH98Alt2Ah1sSy4srcQ4wSHMxKIrxm/u7BQrwpiZVVqUX58UWl
	OanFhxiTgUEwkVlKNDkfmI7ySuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBa
	BLOFiYNTqoFRxvHNx5Wn784KuagXq/b+T/jMlJvHhPdc2XU9Va2i3vByQEjK8vAsq77nC9T3
	Rd/puNyg6notSH5GDk/xq0tH1ga17pk6QWwl/8OeU4Lzg5/Nt9W83a/vs2Lnaj11fb2u100+
	n/MKNfInT+DemOGr4fXK+pLepiPq9duPzEpq2Cuev/hy8dtSJZbijERDLeai4kQAARctpD0D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/11/2014 01:01 PM, Sachin Kamat wrote:
> Hi Chanwoo,
> 
> On 10 April 2014 15:36, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> This patch add new exynos3250.dtsi to support Exynos3250 SoC and includes
>> chipid/sys_reg dt node.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos3250.dtsi | 34 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 34 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
>>
>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
>> new file mode 100644
>> index 0000000..3c8cee6
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>> @@ -0,0 +1,34 @@
>> +/*
>> + * Samsung's Exynos3250 SoC device tree source
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *             http://www.samsung.com
>> + *
>> + * Samsung's Exynos3250 SoC device nodes are listed in this file. Exynos3250
>> + * based board files can include this file and provide values for board specfic
>> + * bindings.
>> + *
>> + * Note: This file does not include device nodes for all the controllers in
>> + * Exynos3250 SoC. As device tree coverage for Exynos3250 increases, additional
>> + * nodes can be added to this file.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include "skeleton.dtsi"
>> +
>> +/ {
>> +       compatible = "samsung,exynos3250";
>> +
>> +       chipid@10000000 {
>> +               compatible = "samsung,exynos4210-chipid";
>> +               reg = <0x10000000 0x100>;
>> +       };
>> +
>> +       sys_reg: syscon@10010000 {
>> +               compatible = "samsung,exynos3-sysreg", "syscon";
>> +               reg = <0x10010000 0x400>;
>> +       };
>> +};
> 
> Shouldn't these be grouped under the soc node?

I don't understand accurate meaning.
Do you have to explain more detailed comment?

Best Regards,
Chanwoo Choi

