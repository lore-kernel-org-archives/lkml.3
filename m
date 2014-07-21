Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaGUIRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:17:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17117 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaGUIRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:17:47 -0400
X-AuditID: cbfee690-b7fb56d000003439-39-53cccca980fb
Message-id: <53CCCCA8.1030509@samsung.com>
Date: Mon, 21 Jul 2014 17:17:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCHv7 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
References: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
 <14522743.f6oFhEQVv4@wuerfel> <53CCCB20.50802@samsung.com>
In-reply-to: <53CCCB20.50802@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42JZI2JSorvyzJlgg0tPZC3+TjrGbnH3+WFG
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWzONv0ht1i0+NrrBYL25awWMw78o7F4vKuOWwW
	M87vY7JYev0ik8WE6WtZLN7emc5i0br3CLvF+hmvWRyEPNbMW8Po8fvXJEaPy329TB4rl39h
	89i8Qstj06pOIGNJvUffllWMHp83yQVwRnHZpKTmZJalFunbJXBlPH16jK1gukDFmQ8sDYx/
	eLoYOTkkBEwkNt+5ww5hi0lcuLeerYuRi0NIYCmjxOlPLxhhir523WKBSExnlOhtfMkK4bwG
	qrrSBFbFK6AlsfrnDxYQm0VAVWLq7mawsWxA8f0vbrCB2KICYRIrp19hgagXlPgx+R6YLSKg
	KDH1xTNmkKHMAgeYJX69ecgMkhAWiJBY/2YX1LYmRomuE4fBtnEKaEqc7VwEVsQsoCOxv3Ua
	G4QtL7F5zVuwSRICWzgkHq6+wgZxkoDEt8mHgNZxACVkJTYdYIb4TVLi4IobLBMYxWYhOWoW
	krGzkIxdwMi8ilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMwGZz+92zCDsZ7B6wPMSYDrZzI
	LCWanA9MJnkl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjE
	wSnVwFgTEv9x5yvrLx8Wi064/O/szroJ++qsb1lP089qtU5gcbwVuXhv6OO1NTtNPt8UCNp7
	cCa/2u60deHKPQv8m0vUYjZsWu9qefPhqVPuvtuDRdNutN0RunEiivGe3fMTKstPXb8zMTOY
	J7vOSnpHK0fnZJVfZgfvLj6aay4ifnb9FD3dHWXvj79UYinOSDTUYi4qTgQADMMAABwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQd2VZ84EG0xfKWLxd9Ixdou7zw8z
	Wsw/co7Vov/NQlaLc69WMlo8aFrFZNG74CqbxdmmN+wWmx5fY7VY2LaExWLekXcsFpd3zWGz
	mHF+H5PF0usXmSwmTF/LYvH2znQWi9a9R9gt1s94zeIg5LFm3hpGj9+/JjF6XO7rZfJYufwL
	m8fmFVoem1Z1AhlL6j36tqxi9Pi8SS6AM6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzA
	UNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6CElhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9
	RgZoIGENY8bTp8fYCqYLVJz5wNLA+Ieni5GTQ0LAROJr1y0WCFtM4sK99WxdjFwcQgLTGSV6
	G1+yQjivGSVOX2liBKniFdCSWP3zB1gHi4CqxNTdzewgNhtQfP+LG2wgtqhAmMTK6VdYIOoF
	JX5MvgdmiwgoSkx98YwZZCizwAFmiV9vHjKDJIQFIiTWv9kFta2JUaLrxGGwbZwCmhJnOxeB
	FTEL6Ejsb53GBmHLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4FTzTGoH48oGi0OMAhyMSjy8HoxngoVYE8uKK3MPMUpwMCuJ8J7IAArxpiRWVqUW
	5ccXleakFh9iNAWGwURmKdHkfGAazCuJNzQ2MTOyNDI3tDAyNlcS5z3Qah0oJJCeWJKanZpa
	kFoE08fEwSnVwMi1Mft0k1qy8skXUfXrma5X3nPYZ2rzy8FFLiTvcY/Fv6uvXn4wEPy92F1Y
	Ibd0kcxtlswH3QdOXKhbzFhx2VlGepKgwZ6V+tNWhDKUXe6+2y7/6Yq8eLp5YFid2lGJENva
	kHrtZbM0+padyJ9XpDDB9spriQirWv6j0/ov28eIrXbcZXx3nRJLcUaioRZzUXEiAHuBfu1L	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 05:11 PM, Chanwoo Choi wrote:
> On 07/21/2014 04:38 PM, Arnd Bergmann wrote:
>> On Monday 21 July 2014 11:17:44 Chanwoo Choi wrote:
>>>
>>> This patchset support Exynos3250 ADC (Analog Digital Converter) because
>>> Exynos3250 has additional special clock for ADC IP.
>>>
>>> Changes from v6:
>>> - Use "exynos3250-adc" compatible string instead of "exynos3250-adc-v2"
>>> - Use "sclk" clock name instead of "sclk_adc"
>>> - Remove un-necessary macro for exyno-adc-data-v2 structure.
>>> - Remove '(void *)' cast and mark the exynos-adc-data structure as 'const'
>>> - Change the number of ADC channels (Exynos3250 has only two channels for ADC)
>>>
>>
>> Looks good to me. Two small requests:
>>
>> a) if you don't mind, can you add my patch (1/2) to add support for s3c64xx to
>>    your series, adding your Signed-off-by line in addition to mine? I think
>>    that one was noncontroversial, while the second patch (2/2) need some more
>>    work to address the comments and do testing.
> 
> OK, I'll add this patch.
> But, I have a question.
> 
> Your patch add following compatible string.
> "s3c64100-adc" is right?
> 
>  static const struct of_device_id exynos_adc_match[] = {
>  	{
> +		.compatible = "samsung,s3c64100-adc",
> +		.data = &exynos_adc_s3c64xx_data,
> +	}, {

Additionally,
Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt has not included
"samsung,s3c6410-adc" compatible string. Should I add this string in exynos-adc.txt?

drivers/iio/adc/exynos-adc.c has not includeded following compatible string.
Should I add this compatible string on exynos-adc.c?

+			Must be "samsung,s3c2410-adc" for
+				the ADC in s3c2410 and compatibles
+			Must be "samsung,s3c2416-adc" for
+				the ADC in s3c2416 and compatibles
+			Must be "samsung,s3c2440-adc" for
+				the ADC in s3c2440 and compatibles
+			Must be "samsung,s3c2440-adc" for
+				the ADC in s3c2440 and compatibles
+			Must be "samsung,s3c2443-adc" for
+				the ADC in s3c2443 and compatibles

Thanks,
Chanwoo Choi
