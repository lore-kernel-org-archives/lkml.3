Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaCQBen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:34:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11130 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaCQBei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:34:38 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-23-5326512bf644
Message-id: <5326512D.9010500@samsung.com>
Date: Mon, 17 Mar 2014 10:34:37 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 5/8] devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
 <1394789408-14648-6-git-send-email-cw00.choi@samsung.com>
 <001501cf4176$3d23daa0$b76b8fe0$%han@samsung.com>
In-reply-to: <001501cf4176$3d23daa0$b76b8fe0$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkSFcnUC3Y4NJDVouOnt8sFvOPnGO1
	OPdqJaPF5YWXWC3ONr1ht1jYtoTF4vKuOWwWn3uPMFrMOL+PyWLp9YtMFrcbV7BZvPlxlsli
	wvS1LBaPV7xlt3h1sI3Fgd9jzbw1jB4rl39h81i85yWTx8/l29k9+rasYvQ4fmM7k8fnTXIe
	G+eGBnBEcdmkpOZklqUW6dslcGVMmbiQqWADT8Wqxk2MDYxLuLoYOTkkBEwkfnxawwJhi0lc
	uLeerYuRg0NIYCmjxCd2EBOkZP+G2C5GLqDodEaJ3nUn2CGcV4wSL24/YgXp5RXQklh9ZR+Y
	zSKgKnFxzV1GEJsNKL7/xQ02EFtUIExi5fQrLBD1ghI/Jt8Ds0UEVCQ+rz8OVsMs8JVJ4uY8
	JhBbWMBP4umfJ8wQy7YySrw/ux+siFPATuL3gl9MEA06Evtbp0E1y0tsXvMWrEFCYC6HxJbJ
	vcwQFwlIfJt8iAXiHVmJTQeYIR6WlDi44gbLBEaxWUhumoVk7CwkYxcwMq9iFE0tSC4oTkov
	MtQrTswtLs1L10vOz93ECIzw0/+e9e5gvH3A+hBjMtDKicxSosn5wASRVxJvaGxmZGFqYmps
	ZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MrXqHGNh/L+CZ9t+iVzvg
	kJrFR9OwQ4sfblwn/vLvl9tX/wcq/Umfv/G0iW7Z5NfdKb9PbEoNXuf/+mrf1o4Fm3oupLi0
	hprpN701XrBds6Keu871ENsevXLHwtvBhTrnPhz7s7xqqvWSky++Mzx9LrZsmsfmnzlXDNqi
	5WcsCLlsUHG2sCv1mhJLcUaioRZzUXEiAEQ7t3sGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jQV3tQLVgg3cnLS06en6zWMw/co7V
	4tyrlYwWlxdeYrU42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY8rEhUwFG3gqVjVu
	YmxgXMLVxcjBISFgIrF/Q2wXIyeQKSZx4d56ti5GLg4hgemMEr3rTrBDOK8YJV7cfsQKUsUr
	oCWx+so+MJtFQFXi4pq7jCA2G1B8/4sbbCC2qECYxMrpV1gg6gUlfky+B2aLCKhIfF5/HKyG
	WeArk8TNeUwgtrCAn8TTP0+YIZZtZZR4f3Y/WBGngJ3E7wW/mCAadCT2t06DapaX2LzmLfME
	RoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBKeSZ1A7GlQ0WhxgF
	OBiVeHgnKKsFC7EmlhVX5h5ilOBgVhLhTTAHCvGmJFZWpRblxxeV5qQWH2JMBgbBRGYp0eR8
	YHrLK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGDAVWRkYT
	/9RsbaO8/Vt//GJ7fKK74uHlK2e39EQuqZpi6b332cr3Juud+fqMlvwu9dI48+EJywK5KZae
	ig1Hpbe0St7+U8pUlypr7SSe4n7xfv93ltimB61u20XORGiwu927Pm23Ub2Z7683qS/j3k9t
	8Wcs3P46M886TOZavYfo2xl9l9YosRRnJBpqMRcVJwIASaZljWUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 03/17/2014 09:17 AM, Jingoo Han wrote:
> On Friday, March 14, 2014 6:30 PM, Chanwoo Choi wrote:
>>
>> This patch use SET_SYSTEM_SLEEP_PM_OPS macro instead of legacy method.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/devfreq/exynos/exynos4_bus.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
>> index 60539e8..e5d2c5a 100644
>> --- a/drivers/devfreq/exynos/exynos4_bus.c
>> +++ b/drivers/devfreq/exynos/exynos4_bus.c
>> @@ -1247,6 +1247,7 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
>>  	return 0;
>>  }
>>
>> +#ifdef CONFIG_PM_SLEEP
>>  static int exynos4_busfreq_resume(struct device *dev)
>>  {
>>  	struct busfreq_data *data = dev_get_drvdata(dev);
>> @@ -1254,9 +1255,10 @@ static int exynos4_busfreq_resume(struct device *dev)
>>  	busfreq_mon_reset(data);
>>  	return 0;
>>  }
>> +#endif
>>
>>  static const struct dev_pm_ops exynos4_busfreq_pm = {
>> -	.resume	= exynos4_busfreq_resume,
>> +	SET_SYSTEM_SLEEP_PM_OPS(NULL, exynos4_busfreq_resume)
> 
> Hi Chanwoo Choi,
> 
> How about using SIMPLE_DEV_PM_OPS instead of SET_SYSTEM_SLEEP_PM_OPS?
> SIMPLE_DEV_PM_OPS is simpler as below.
> 
> static SIMPLE_DEV_PM_OPS(exynos4_busfreq_pm, NULL, exynos4_busfreq_resume);
> 
> However, if runtime pm functions will be added later,
> SIMPLE_DEV_PM_OPS is not necessary.
> 

OK, I'll use SIMPLE_DEV_PM_OPS on next patchset.

Best Regards,
Chanwoo Choi


