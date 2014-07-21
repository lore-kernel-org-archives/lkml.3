Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaGUILZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:11:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15544 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaGUILV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:11:21 -0400
X-AuditID: cbfee68f-b7fef6d000003970-b6-53cccb215e24
Message-id: <53CCCB20.50802@samsung.com>
Date: Mon, 21 Jul 2014 17:11:12 +0900
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
 <14522743.f6oFhEQVv4@wuerfel>
In-reply-to: <14522743.f6oFhEQVv4@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42JZI2JSpKt4+kywwe4r3BZ/Jx1jt7j7/DCj
	xfwj51gt+t8sZLU492olo8WDplVMFr0LrrJZnG16w26x6fE1VouFbUtYLOYdecdicXnXHDaL
	Gef3MVksvX6RyWLC9LUsFm/vTGexaN17hN1i/YzXLA5CHmvmrWH0+P1rEqPH5b5eJo+Vy7+w
	eWxeoeWxaVUnkLGk3qNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgyvm1RLFgqWrFlUWQD4xb+
	LkZODgkBE4m27rNsELaYxIV764FsLg4hgaWMElffdrLBFD28fZ8RxBYSmM4oMaHfCaLoNaPE
	+l0PmEESvAIaEo/n3WDtYuTgYBFQlfh92B0kzCagJbH/xQ2wOaICYRIrp19hgSgXlPgx+R6Y
	LSKgKDH1xTNmkJnMAgeYJX69eQg2U1ggQmL9m12sEItTJY7ceMAGMp8TaOjeY2EgYWYBHYn9
	rdPYIGx5ic1r3oLNkRDYwSHxd9kMsDksAgIS3yYfYgHplRCQldh0gBniL0mJgytusExgFJuF
	5KRZSMbOQjJ2ASPzKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzAFHD637P+HYx3D1gfYkwG
	WjmRWUo0OR+YQvJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA6PdytCGpfP6FZctu6jKctVbd+d6xRXbzSIf9BVqfjdYa53F9OH6sban3Qc96ngj
	P1/o7xL6qiF7gXvZo4s58n0ica0P21sO2Dgv2yZwTz91bt4DRvszlTN1qrIDJ3b8L/SX5p5u
	8H3J+jjZgG/3Tz5OWBJ3dd+RLK4arX9NLw7PYTRt82VrOaTEUpyRaKjFXFScCAAK1fEAFwMA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV3F02eCDW6uZbT4O+kYu8Xd54cZ
	LeYfOcdq0f9mIavFuVcrGS0eNK1isuhdcJXN4mzTG3aLTY+vsVosbFvCYjHvyDsWi8u75rBZ
	zDi/j8li6fWLTBYTpq9lsXh7ZzqLReveI+wW62e8ZnEQ8lgzbw2jx+9fkxg9Lvf1MnmsXP6F
	zWPzCi2PTas6gYwl9R59W1YxenzeJBfAGdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZg
	qGtoaWGupJCXmJtqq+TiE6DrlpkD9JCSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILge
	IwM0kLCGMePbFsWCpaIVWxZFNjBu4e9i5OSQEDCReHj7PiOELSZx4d56NhBbSGA6o8SEfqcu
	Ri4g+zWjxPpdD5hBErwCGhKP591g7WLk4GARUJX4fdgdJMwmoCWx/8UNsF5RgTCJldOvsECU
	C0r8mHwPzBYRUJSY+uIZM8hMZoEDzBK/3jwEmyksECGx/s0uVojFqRJHbjxgA5nPCTR077Ew
	kDCzgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L
	10vOz93ECE4wz6R2MK5ssDjEKMDBqMTD68F4JliINbGsuDL3EKMEB7OSCO+JDKAQb0piZVVq
	UX58UWlOavEhRlNgAExklhJNzgcmv7ySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp2amp
	BalFMH1MHJxSDYwOueKbz0j+O3+t9NntdZX5NS4xFpP2LeoI/bq460PQXdu0w/VnDikH5YbN
	2z1ZZTWXO2sLj8bbO0damhtkE5hkC3ZNrZvy7fbFTjt35hyt9XsvRnBG3Mz+Ks/+4ljar41y
	9UfNdoe6dR43czua4PBgb0bN5l3/U7mKXqekbzLp+R9QwXs2tkSJpTgj0VCLuag4EQDuTp37
	RgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 04:38 PM, Arnd Bergmann wrote:
> On Monday 21 July 2014 11:17:44 Chanwoo Choi wrote:
>>
>> This patchset support Exynos3250 ADC (Analog Digital Converter) because
>> Exynos3250 has additional special clock for ADC IP.
>>
>> Changes from v6:
>> - Use "exynos3250-adc" compatible string instead of "exynos3250-adc-v2"
>> - Use "sclk" clock name instead of "sclk_adc"
>> - Remove un-necessary macro for exyno-adc-data-v2 structure.
>> - Remove '(void *)' cast and mark the exynos-adc-data structure as 'const'
>> - Change the number of ADC channels (Exynos3250 has only two channels for ADC)
>>
> 
> Looks good to me. Two small requests:
> 
> a) if you don't mind, can you add my patch (1/2) to add support for s3c64xx to
>    your series, adding your Signed-off-by line in addition to mine? I think
>    that one was noncontroversial, while the second patch (2/2) need some more
>    work to address the comments and do testing.

OK, I'll add this patch.
But, I have a question.

Your patch add following compatible string.
"s3c64100-adc" is right?

 static const struct of_device_id exynos_adc_match[] = {
 	{
+		.compatible = "samsung,s3c64100-adc",
+		.data = &exynos_adc_s3c64xx_data,
+	}, {

> 
> b) For the "compatible" string, I think it makes sense to set a fallback to
>    "samsung,exynos-adc-v2" in the case for exynos3250, making the DT
>    representation
> 
> 	compatible = "samsung,exynos3250-adc", "samsung,exynos-adc-v2";
> 
>    It's not entirely compatible because of the addition of the clock, but
>    since the register layout is the same, I think it still make sense.

OK, I'll add it in exynos3250.dtsi as following:

                adc: adc@126C0000 {
-                       compatible = "samsung,exynos-adc-v3";
+                       compatible = "samsung,exynos3250-adc",
+                                    "samsung,exynos-adc-v2";
                        reg = <0x126C0000 0x100>, <0x10020718 0x4>;
                        interrupts = <0 137 0>;
-                       clock-names = "adc", "sclk_tsadc";
+                       clock-names = "adc", "sclk";
                        clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
                        #io-channel-cells = <1>;
                        io-channel-ranges;

Thanks,
Chanwoo Choi

> 
> Thanks.
> 
> For the entire series,
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

