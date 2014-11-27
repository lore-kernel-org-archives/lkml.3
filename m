Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaK0KtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:49:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26696 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaK0KtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:49:05 -0500
X-AuditID: cbfee68d-f79296d000004278-b1-5477019c906e
Message-id: <5477019C.50101@samsung.com>
Date: Thu, 27 Nov 2014 19:49:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de,
        olof@lixom.net, catalin.marinas@arm.com, will.deacon@arm.com,
        s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [01/19] pinctrl: exynos: Add support for Exynos5433
References: <1417073716-22997-2-git-send-email-cw00.choi@samsung.com>
 <5476FC4E.7030505@samsung.com>
In-reply-to: <5476FC4E.7030505@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWyRsSkWHcOY3mIwbbbNhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWU/4sZ7LY9Pgaq8Xl
	XXPYLGac38dksfT6RSaLU9c/s1ks2vqF3eLwm3ZWixmTX7JZHJuxhNFi1a4/jBYvP55gcRDz
	WDNvDaPH71+TGD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6M6zNOshRM1ajY2afRwNio2MXIySEhYCIxdfldZghbTOLCvfVsXYxcHEICSxkl9l28zw5T
	NO//LkaIxHRGiVkLlrJCOK8ZJW4deArUzsHBK6AhseKbGUgDi4CqROPFHWBT2QS0JPa/uMEG
	YosKhEmsnH6FBcTmFRCU+DH5HpgtIqAt0Xn5HthMZoG5LBIL1vxlBEkICzhIPGncC9YsJJAm
	8Wh9C9hFnEANy+fNZAHZyyygJ3H/ohZImFlAXmLzmrdQ39zgkPi9tAbiHgGJb5MPgZVLCMhK
	bDoAVSIpcXDFDZYJjGKzkFw0C2HoLCRDFzAyr2IUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQI
	TBCn/z3r3cF4+4D1IUYBDkYlHl6LA2UhQqyJZcWVuYcYTYGOmMgsJZqcD0xDeSXxhsZmRham
	JqbGRuaWZkrivIpSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJ5dOvWCaaBA1sqnk52U
	PGd9mJB1RNolgzUwPY1hG39FAMeKrz9l5/xaZTiNfzWbyrLe0o33NfmEdm/jCHxmHP2PKW/x
	pBWxeSH3kyedfe8gx60TVnNlinf8pOLY7Alll/K3rN/2NJ2/TCtFfs6G/F7xid7fegKMPFbe
	MW6aut704K1aJ87aCUosxRmJhlrMRcWJANztP4oLAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQd05jOUhBvMvGVo8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbTPmznMli0+NrrBaX
	d81hs5hxfh+TxdLrF5ksTl3/zGaxaOsXdovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZlyfcZKlYKpGxc4+jQbGRsUuRk4OCQETiXn/dzFC
	2GISF+6tZ+ti5OIQEpjOKDFrwVJWCOc1o8StA0+Zuxg5OHgFNCRWfDMDaWARUJVovLiDGcRm
	E9CS2P/iBhuILSoQJrFy+hUWEJtXQFDix+R7YLaIgLZE5+V7YDOZBeaySCxY8xdss7CAg8ST
	xr1gzUICaRKP1rewg9icQA3L581kAdnLLKAncf+iFkiYWUBeYvOat8wTGAVmIVkxC6FqFpKq
	BYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCE9AzqR2MKxssDjEKcDAq8fBaHCgLEWJN
	LCuuzD3EKMHBrCTCywVMX0K8KYmVValF+fFFpTmpxYcYTYEBMJFZSjQ5H5gc80riDY1NzIws
	jcwNLYyMzZXEeW/czA0REkhPLEnNTk0tSC2C6WPi4JRqYFwi4hiWuGLRJiPBoztdN3Cc8eK+
	vss+qY7Nlk8tLHqXRG5zdKPxoRUeq+dMmLx/zsWfHZG2Pzb3pu8/35Zm6aAjG9py+mr/krCA
	v2uz9R3dkk4FZfMv0n4XkHHLmfUk698fgr0XfDm37XxyYeGT+6m1y0IOfVq7s29twA//YI0D
	pi2OTJqfvyixFGckGmoxFxUnAgAVEF3VVgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 11/27/2014 07:26 PM, Pankaj Dubey wrote:
> Hi Chanwoo,
> 
> On Thursday 27 November 2014 01:04 PM, Chanwoo Choi wrote:
>> This patch adds driver data for Exynos5433 SoC. Exynos5433 includes 228 multi-
>> functional input/output port pins and 135 memory port pins. There are 41 general
>> port groups and 2 memory port groups.
>>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Cc: Thomas Abraham <thomas.abraham@linaro.org>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>>
>> ---
>> drivers/pinctrl/samsung/pinctrl-exynos.c  | 163 ++++++++++++++++++++++++++++++
>>   drivers/pinctrl/samsung/pinctrl-samsung.c |   2 +
>>   drivers/pinctrl/samsung/pinctrl-samsung.h |   1 +
>>   3 files changed, 166 insertions(+)
>>
>> diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
>> index 8e3e0c0..bd4c4ec 100644
>> --- a/drivers/pinctrl/samsung/pinctrl-exynos.c
>> +++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
>> @@ -1268,6 +1268,169 @@ struct samsung_pin_ctrl exynos5420_pin_ctrl[] = {
>>       },
>>   };
>>
>> +/* pin banks of exynos5433 pin-controller - ALIVE */
>> +static struct samsung_pin_bank exynos5433_pin_banks0[] = {
>> +    EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
>> +    EXYNOS_PIN_BANK_EINTW(8, 0x020, "gpa1", 0x04),
>> +    EXYNOS_PIN_BANK_EINTW(8, 0x040, "gpa2", 0x08),
>> +    EXYNOS_PIN_BANK_EINTW(8, 0x060, "gpa3", 0x0c),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - AUD */
>> +static struct samsung_pin_bank exynos5433_pin_banks1[] = {
>> +    EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz0", 0x00),
>> +    EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpz1", 0x04),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - CPIF */
>> +static struct samsung_pin_bank exynos5433_pin_banks2[] = {
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x000, "gpv6", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - eSE */
>> +static struct samsung_pin_bank exynos5433_pin_banks3[] = {
>> +    EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj2", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - FINGER */
>> +static struct samsung_pin_bank exynos5433_pin_banks4[] = {
>> +    EXYNOS_PIN_BANK_EINTG(4, 0x000, "gpd5", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - FSYS */
>> +static struct samsung_pin_bank exynos5433_pin_banks5[] = {
>> +    EXYNOS_PIN_BANK_EINTG(6, 0x000, "gph1", 0x00),
>> +    EXYNOS_PIN_BANK_EINTG(7, 0x020, "gpr4", 0x04),
>> +    EXYNOS_PIN_BANK_EINTG(5, 0x040, "gpr0", 0x08),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr1", 0x0c),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x080, "gpr2", 0x10),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpr3", 0x14),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - IMEM */
>> +static struct samsung_pin_bank exynos5433_pin_banks6[] = {
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpf0", 0x00),
> 
> Is this complete?

Exynos5433 has gpf1~gpf5. But, This patch did not include gpf1~gpf5.
because gpf1~gpf5 of Exynos5433 has different offset of EINT register.

gpf1~gpf5 is included in IMEM (0x11090000) part But,EINT register of gpf1~gpf5
is included in ALIVE (0x10580000) part. So, I'll consider how to support
gpf1~gpf5 gpios.

> 
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - NFC */
>> +static struct samsung_pin_bank exynos5433_pin_banks7[] = {
>> +    EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj0", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - PERIC */
>> +static struct samsung_pin_bank exynos5433_pin_banks8[] = {
>> +    EXYNOS_PIN_BANK_EINTG(6, 0x000, "gpv7", 0x00),
>> +    EXYNOS_PIN_BANK_EINTG(5, 0x020, "gpb0", 0x04),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpc0", 0x08),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x060, "gpc1", 0x0c),
>> +    EXYNOS_PIN_BANK_EINTG(6, 0x080, "gpc2", 0x10),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpc3", 0x14),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x0c0, "gpg0", 0x18),
>> +    EXYNOS_PIN_BANK_EINTG(4, 0x0e0, "gpd0", 0x1c),
>> +    EXYNOS_PIN_BANK_EINTG(6, 0x100, "gpd1", 0x20),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x120, "gpd2", 0x24),
>> +    EXYNOS_PIN_BANK_EINTG(5, 0x140, "gpd4", 0x28),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x160, "gpd8", 0x2c),
>> +    EXYNOS_PIN_BANK_EINTG(7, 0x180, "gpd6", 0x30),
>> +    EXYNOS_PIN_BANK_EINTG(3, 0x1a0, "gpd7", 0x34),
>> +    EXYNOS_PIN_BANK_EINTG(5, 0x1c0, "gpg1", 0x38),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x1e0, "gpg2", 0x3c),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x200, "gpg3", 0x40),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - TOUCH */
>> +static struct samsung_pin_bank exynos5433_pin_banks9[] = {
>> +    EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj1", 0x00),
>> +};
>> +
>> +/*
>> + * Samsung pinctrl driver data for Exynos5433 SoC. Exynos5433 SoC includes
>> + * four gpio/pin-mux/pinconfig controllers.
> 
> four? I can see you added 10.

You're right. I'll fix it.

Best Regards,
Chanwoo Choi
