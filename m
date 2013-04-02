Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976Ab3DBKEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:04:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62015 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab3DBKEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:04:37 -0400
X-AuditID: cbfee690-b7f656d0000007e3-c5-515aad348d55
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1364570435.1345.82.camel@x61.thuisdomein>
In-reply-to: <1364570435.1345.82.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: Fix typo "CONFIG_SAMSUNG_DEV_RTC"
Date: Tue, 02 Apr 2013 19:04:35 +0900
Message-id: <237b01ce2f89$7af00b60$70d02220$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4skPeG5cM2sFgLTXuE02BEAtsvOQC+CB2A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ12TtVGBBud6hSwmrTvAZLHp8TVW
	i8u75rBZzDi/j8ni9mVei0W3zjA7sHm0NPewefxd9YLZY/OSeo+N258weXzeJBfAGsVlk5Ka
	k1mWWqRvl8CVsen6fZaCqzwVX6f+Z29gPMvVxcjJISFgInFn6jNmCFtM4sK99WxdjFwcQgLL
	GCXmNq5mhSnauLuDFSKxiFHiyptnTBDOX0aJDxuvsIFUsQloSBx+/4wdxBYRKJbYvOcaUBEH
	B7NAtsSWV0wgYSEBM4kNXXNZQGxOAXOJuy+Xg20WFrCWOPt6JpjNIqAq0fz3FSNIK6+ArcTb
	O7kgYV4BQYkfk++xQExUl5gyBSzMLKAt8eTdBVaQsARQ+NFfXYj9RhL/Jp1hgigRkdj34h0j
	yMESAi/ZJXb3LmCD2CQg8W3yIRaIXlmJTQegwSApcXDFDZYJjBKzkCyehbB4FpLFs5BsWMDI
	sopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJFIn7GC8d8D6EGMy0PaJzFKiyfnASM8riTc0
	NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2NGpkLfpyIW
	Cc/T7sYndVfzO2uIL5jNbKR/rVN/Q1Dd6ewla7fHX8j2fhkrfOnprXTZowwx1anVDId6nwVq
	BB7ysw5+7+LQWLrvYfHh6yFXmhxTPUP6jzqcfL3UKtyum4F3g2B7q1TnptXKgSLdD/VZ//hs
	7K14t7nhxX22eaLXjjok2Ld/V2Ipzkg01GIuKk4EAC5t2eXqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV2TtVGBBnv7uC0mrTvAZLHp8TVW
	i8u75rBZzDi/j8ni9mVei0W3zjA7sHm0NPewefxd9YLZY/OSeo+N258weXzeJBfAGtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPT9fssBVd5Kr5O/c/ewHiWq4uRk0NC
	wERi4+4OVghbTOLCvfVsXYxcHEICixglrrx5xgTh/GWU+LDxChtIFZuAhsTh98/YQWwRgWKJ
	zXuuARVxcDALZEtsecUEEhYSMJPY0DWXBcTmFDCXuPtyOTOILSxgLXH29Uwwm0VAVaL57ytG
	kFZeAVuJt3dyQcK8AoISPybfY4GYqC4xZQpYmFlAW+LJuwusIGEJoPCjv7oQ+40k/k06wwRR
	IiKx78U7xgmMQrOQDJqFMGgWkkGzkHQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGc
	Bp5J7WBc2WBxiFGAg1GJh9dhTmSgEGtiWXFl7iFGCQ5mJRHerbpRgUK8KYmVValF+fFFpTmp
	xYcYk4G+nMgsJZqcD0xReSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZ
	wsTBKdXAqN8qkHLG6E/Krp5VZgrrZdu//5u7duUXhaj9qlstrm974MwQeIpv8vwAC8Ppd6Ze
	DU8QrIixMpo348EDmbSNESLPl2RP4V/tFHjnvmzwgazf+6Z/ucPtb5YScObZHL1L/1JUDtya
	x7i0kXf/tq7Iw6vvPZR5fknsYPOe+s4Y2Zcq2sels9bl3FBiKc5INNRiLipOBABZ6gArRwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> s3c_rtc_setname() tests for CONFIG_SAMSUNG_DEV_RTC or
> CONFIG_PLAT_S3C24XX. But of these two macros only CONFIG_PLAT_S3C24XX
> actually exists. Now we can see that s3c_device_rtc is only defined if
> either CONFIG_PLAT_S3C24XX or CONFIG_S3C_DEV_RTC are defined. So,
> apparently, it was intended to use CONFIG_S3C_DEV_RTC here.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) Introduced in commit commit b2994d318dc78c9a4a43605629f00217335ada28
> ("ARM: S3C2443/S3C2416: add s3c_rtc_setname and rename rtc devices"),
> which shipped in v3.4. Should this go to stable too (after testing)?
> 
Let me check again, and if required, I will add Cc to stable.

>  arch/arm/plat-samsung/include/plat/rtc-core.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/plat-samsung/include/plat/rtc-core.h
> b/arch/arm/plat-samsung/include/plat/rtc-core.h
> index 21d8594..7b542f7 100644
> --- a/arch/arm/plat-samsung/include/plat/rtc-core.h
> +++ b/arch/arm/plat-samsung/include/plat/rtc-core.h
> @@ -19,7 +19,7 @@
>  /* re-define device name depending on support. */
>  static inline void s3c_rtc_setname(char *name)
>  {
> -#if defined(CONFIG_SAMSUNG_DEV_RTC) || defined(CONFIG_PLAT_S3C24XX)
> +#if defined(CONFIG_S3C_DEV_RTC) || defined(CONFIG_PLAT_S3C24XX)

Yes, according to devs.c file in plat-samsung, SAMSUNG_DEV_RTC should be changed to S3C_DEV_RTC.

>  	s3c_device_rtc.name = name;
>  #endif
>  }
> --
> 1.7.11.7

Will apply after checking about stable, thanks.

- Kukjin

