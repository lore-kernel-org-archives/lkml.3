Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaD1LFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:05:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19693 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbaD1LE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:04:58 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-78-535e35d9a7a4
Message-id: <535E3A0D.4000501@samsung.com>
Date: Mon, 28 Apr 2014 20:22:53 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com
Subject: Re: [PATCH v2 1/5] ARM: dts: Add syscon handle in pmu node for
 exynos5250
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
 <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
 <1398426857-5097-2-git-send-email-pankaj.dubey@samsung.com>
 <535ACBC8.5090703@gmail.com>
In-reply-to: <535ACBC8.5090703@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zQ92bpnHBBjNvslssm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsmjde4TdYv2M1ywWq3b9YbTY0bKaxYHLY+esu+wem1Z1
	snlsXlLv0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBnn/n9iL7ipVdG26ip7A+MmxS5GTg4J
	AROJJROWMUHYYhIX7q1n62Lk4hASWMYocej9PxaYomMHLzFBJKYzShy4vQzKec0osXNCMztI
	Fa+AlsTnvkusIDaLgKpE58rNjCA2m4CuxJP3c5lBbFGBMIlN0/tYIeoFJX5Mvge2QURAXeLb
	lH52kKHMAj8ZJVouzANrFhYIkTi68Sg7xLZHjBIPJx0ES3AKaErs/L6ODcRmFrCWWDlpGyOE
	LS+xec1bZpAGCYG37BKT/51ngThJQOLb5ENANgdQQlZi0wFmiN8kJQ6uuMEygVFsFpKjZiEZ
	OwvJ2AWMzKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQiJzwg7GewesDzEmA62cyCwlmpwP
	jOy8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamB0
	YrbP1BN5vm+d2aTv5rPbN2i+a713J1IzwF5UmDPUuMH+dvuL6MOTNzOZtt7M6VM0Wmi+84ju
	bdnMwLcz2g7PO82Zv2HRYf5eo4BYl/R55d1GHWs+XLm6gS/W0jRtA9uRuktPZTkv5vDbnHHt
	qxN2mhrz0zCzcOOOf/wixnI/Tocc+P5uwiElluKMREMt5qLiRACrUMm74gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd2bpnHBBu0/GC2WTbrLZjH/yDlW
	i94FV9ksNj2+xmpxedccNosZ5/cxWbTuPcJusX7GaxaLVbv+MFrsaFnN4sDlsXPWXXaPTas6
	2Tw2L6n36NuyitHj8ya5ANaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ
	5/5/Yi+4qVXRtuoqewPjJsUuRk4OCQETiWMHLzFB2GISF+6tZ+ti5OIQEpjOKHHg9jImCOc1
	o8TOCc3sIFW8AloSn/susYLYLAKqEp0rNzOC2GwCuhJP3s9lBrFFBcIkNk3vY4WoF5T4Mfke
	C4gtIqAu8W1KPzvIUGaBn4wSLRfmgTULC4RIHN14lB1i2yNGiYeTDoIlOAU0JXZ+X8cGYjML
	WEusnLSNEcKWl9i85i3zBEaBWUiWzEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwXH/THoH46oGi0OMAhyMSjy8EXNig4VYE8uKK3MPMUpwMCuJ8O6XiAsW4k1JrKxKLcqP
	LyrNSS0+xJgMDIOJzFKiyfnAlJRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTU
	gtQimC1MHJxSDYw8L04v0rqjFB/zwOAKg7D4718zjb9otu4LqtBVNcns+8j09dKutPnTJm1T
	jj2aICUdtdWJy/fUIb+SfVyX3/K4NnfmVjs8OnPknmD+vc+eznnll/VYfYv/vPSXvb7oU+bC
	ecsWBq1fv+L+0sBNc7XaYgtCuLwef6tYFnH1wsdIqeZMdoecfzVKLMUZiYZazEXFiQDkQZlU
	PwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04/26/2014 05:55 AM, Tomasz Figa wrote:
> Hi Pankaj,
>
> On 25.04.2014 13:54, Pankaj Dubey wrote:
>> Add "samsung,syscon-phandle" property pointing to PMU node
>> to access PMU register via PMU regmap handle.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/boot/dts/exynos5250.dtsi |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi 
>> b/arch/arm/boot/dts/exynos5250.dtsi
>> index 3742331..52801af 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -173,6 +173,7 @@
>>       pmu_system_controller: system-controller@10040000 {
>>           compatible = "samsung,exynos5250-pmu", "syscon";
>>           reg = <0x10040000 0x5000>;
>> +        samsung,syscon-phandle = <&pmu_system_controller>;
>>       };
>>
>>       watchdog@101D0000 {
>>
>
> This looks strange. A node that refers back to itself. If I understand 
> correctly, you are relying on the fact that if you don't use platform_driver 
> model for the PMU driver, it won't bind to this node and instead the generic 
> syscon driver will. I'm afraid this is incorrect, because the PMU driver 
> should normally use the driver model.

No, let me explain you, property "samsung, syscon-phandle" referring back to 
it's own node
and I am not using platform_driver model for PMU driver are not related with 
each other.

We added "samsung, syscon-phandle" property to PMU node, as current syscon API's 
to get regmap
such as "syscon_regmap_lookup_by_phandle" expects "property_name" to lookup for 
proper device_node
which has regmap. So if we are passing PMU device_node to such API we should 
have that property under
PMU device node. So even though it's looking strange I do not think it's wrong.

But still since, you pointed out I checked syscon APIs carefully and found that 
we can avoid such property
which refers back to itself if we modify syscon APIs and allow them to accept 
"property" parameter as NULL,
assuming that device_node passed itself has regmap handle, following 
modification worked for me and if
it is acceptable I do not need to add such property in PMU device node.

==========
struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
                      const char *property)
  {
      struct device_node *syscon_np;
      struct regmap *regmap;
-
-    syscon_np = of_parse_phandle(np, property, 0);
-    if (!syscon_np)
-        return ERR_PTR(-ENODEV);
-
-    regmap = syscon_node_to_regmap(syscon_np);
-    of_node_put(syscon_np);
-
+
+    if (property) {
+        syscon_np = of_parse_phandle(np, property, 0);
+        if (!syscon_np)
+            return ERR_PTR(-ENODEV);
+
+        regmap = syscon_node_to_regmap(syscon_np);
+        of_node_put(syscon_np);
+    } else {
+        regmap = syscon_node_to_regmap(np);
+    }
      return regmap;
  }
=============

Other problem as you are seeing that current patch does not uses platform_driver 
model for PMU
is because PMU device node has two compatibility string and "syscon" driver is 
getting registered as
core_initcall, much before PMU registration. So only "syscon" driver's probe is 
getting called. So it does
not depend whether we have this property in PMU device node or we do not have.

>
> I see two possible options to solve this problem:
>
> 1) Instead, the PMU driver should bind to this node and become a syscon 
> provider. This will require a small change in the syscon API, which would be 
> reasonable anyway:
>
>  a) instead of using driver_find_device() and dev_get_drvdata() in 
> syscon_node_to_regmap(), a local list of syscon structs should be kept in this 
> driver and then the look-up would just iterate over this list, that could 
> contain external syscon implementations as well,
>
>  b) syscon_register() function should be provided to register an external 
> syscon provider from other drivers, like Exynos PMU driver.
>
> Another solution would be:
>
> 2) Register a static platform device from Exynos PMU driver, with .of_node set 
> to PMU node and .name to "syscon" to instantiate the syscon device and create 
> a syscon provider, even though the PMU driver would be bound to the node.

I do not understand you here. Will you please explain a bit more here?

How come two driver with same ".name" can be registered? I can see if "syscon" 
driver
registration comes first, static registration from PMU driver, with same .name 
will fail.
Please correct me if I am wrong.


>
> The change mentioned in point 1.a) should be implemented regardless of which 
> solution is chosen, as iterating over all devices in the system and relying on 
> their driver_data is rather a poor practice. A local list would be faster - 
> all syscons to iterate over, instead of all devices in the system, and more 
> flexible - a single device could be a provider of multiple resources.

Your suggestion 1.a) worked well and I modified and tested it also.
So probably I can send that patch separately. Even though I can't see this 
helping me to convert PMU
as platform_driver model.

>
> As for the solution for Exynos PMU itself, I tend to prefer 2), as it wouldn't 
> require additional functions exported from the syscon driver.
>
> Best regards,
> Tomasz
>


-- 
Best Regards,
Pankaj Dubey

