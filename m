Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbaH1Et3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 00:49:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50469 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaH1Et1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 00:49:27 -0400
X-AuditID: cbfee68e-f79536d000000fd1-bb-53feb4d5a8dd
Message-id: <53FEB4D5.8000704@samsung.com>
Date: Thu, 28 Aug 2014 13:49:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCHv2 1/5] rtc: s3c: Define s3c_rtc structure to remove global
 variables.
References: <y@samsung.com> <1407808871-6046-1-git-send-email-y@samsung.com>
 <1407808871-6046-2-git-send-email-y@samsung.com>
 <20140822134204.1fa5be7aeb76a50b45ccc5f5@linux-foundation.org>
 <53FA89FD.1030004@samsung.com>
 <20140826143149.7cd3ab27b6247a59a486e681@linux-foundation.org>
In-reply-to: <20140826143149.7cd3ab27b6247a59a486e681@linux-foundation.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkWPfqln/BBvuvq1gsuXiV3WLO+jVs
	Fr0LrrJZnG16w25xedccNosZ5/cxWezv7GB0YPfYM/Ekm8eJGb9ZPPq2rGL0mD7vJ5PH501y
	AaxRXDYpqTmZZalF+nYJXBmv3/xgKXghUrFi4gSWBsb7Al2MnBwSAiYSU55fYYGwxSQu3FvP
	1sXIxSEksJRR4smch4wwRZ8/nWaGSExnlNjcs4cFwnnNKPFq/gMmkCpeAS2Jx8f6wDpYBFQl
	dr1czQxiswHF97+4wQZiiwqESaycDrGOV0BQ4sfke2C2iICuxKrnu8DqmQVWAw09rQ9iCwtE
	S/za+ZkRYtkiJolVZ66CDeIU8JZYtf0vI0SDjsT+1mlsELa8xOY1b8FOlRA4xi6x6+xNVoiL
	BCS+TT4EtI0DKCErsekAM8RrkhIHV9xgmcAoNgvJTbOQjJ2FZOwCRuZVjKKpBckFxUnpRUZ6
	xYm5xaV56XrJ+bmbGIGxd/rfs74djDcPWB9iFOBgVOLhdYj7FyzEmlhWXJl7iNEU6IqJzFKi
	yfnACM8riTc0NjOyMDUxNTYytzRTEudNkPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR
	zvPAyl9S/g80Yp5efjR5p2C8UNTpxru3ZHTi2kVTpF4+fGfZpPqI45NF0XqtJ5vl3RaZ7tnx
	oYtTWEzi3T7/q3r3VGPLLn1MffI2WuWzwgPTIreL7J427vxWh5a3et5/zabAUWdrVX1dvWNt
	UJzM3+0TZK/Hlv5bKTrJ+sOCuh3Btxb+0U1TYinOSDTUYi4qTgQAnqD/wrgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd2rW/4FG5xcIGux5OJVdos569ew
	WfQuuMpmcbbpDbvF5V1z2CxmnN/HZLG/s4PRgd1jz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMeP3mB0vBC5GKFRMnsDQw
	3hfoYuTkkBAwkfj86TQzhC0mceHeerYuRi4OIYHpjBKbe/awQDivGSVezX/ABFLFK6Al8fhY
	HyOIzSKgKrHr5Wqwbjag+P4XN9hAbFGBMImV06+wQNQLSvyYfA/MFhHQlVj1fBdYPbPAaqCh
	p/VBbGGBaIlfOz8zQixbxCSx6sxVsEGcAt4Sq7b/ZYRo0JHY3zqNDcKWl9i85i3zBEaBWUh2
	zEJSNgtJ2QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZH9TGoH48oGi0OMAhyMSjy8
	DnH/goVYE8uKK3MPMUpwMCuJ8KaDhHhTEiurUovy44tKc1KLDzGaAoNgIrOUaHI+MOnklcQb
	GpuYGVkamRtaGBmbK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpg3Ju12TJheqiqyHqB6ecv
	z/30LkzWV/JPXo3E/MNfCrL+5N77mpn4e4V2JbtfmGbR3pJe3YTdv6+4zZiYr2YvceXTfI5e
	r52ZKy1TJ3+SErUWOtnRYya5wn/dGuPE7R+iPB082CbVc24RebTl9SG3lk+9L0QnP633Wrt0
	P1NNhMktqY0z+WQ0lViKMxINtZiLihMB5tRvigIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,

On 08/27/2014 06:31 AM, Andrew Morton wrote:
> On Mon, 25 Aug 2014 09:57:33 +0900 Chanwoo Choi <cw00.choi@samsung.com> wrote:
> 
>> Dear Andrew, 
>>
>> On 08/23/2014 05:42 AM, Andrew Morton wrote:
>>> On Tue, 12 Aug 2014 11:01:07 +0900 y@samsung.com wrote:
>>>
>>>> This patch define s3c_rtc structure including necessary variables for S3C RTC
>>>> device instead of global variables. This patch improves the readability by
>>>> removing global variables.
>>>
>>> Below is the v1->v2 delta.
>>>
>>> Why were all those tests of info->base added?  Can it really be zero? 
>>> I don't see how.
>>
>> If some functions (e.g., s3c_rtc_settime) accesses the rtc register
>> by using info->base before the initialization of info->base in s3c_rtc_probe,
>> I thought that null pointer error would happen.
> 
> probe() should be called before anything else.  If we're somehow
> calling s3c_rtc_settime() before probe() has completed then something
> very bad is happening - for example, the device may have been
> registered far too early.  But I don't think that's the case here.

I means that existing rtc-s3c.c driver executed s3c_rtc_settime() in s3c_rtc_probe()
before initialization of info->base. But, It is my mistake. so, I modified it just as following:

-		s3c_rtc_settime(NULL, &rtc_tm);
+		s3c_rtc_settime(&pdev->dev, &rtc_tm);

> 
> That being said, it does seem strange that s3c_rtc_probe() calls
> devm_rtc_device_register() *before* trying to request its IRQs.  So if
> IRQ requesting fails, we go and immediately unregister the device. 
> Some other drivers do it this way, others do not.  Wouldn't it be
> better to defer registration until we know that all the probe() setup
> operations have succeeded?

You're right. I missed this point. If rtc-s3c.c driver completed the probe function,
info->base has always right address.

+	if (!info->base)
+		return -EINVAL;
+

As you said, checking state of 'info-base' is un-needed.
I'll send new patchset(v3) to fix it.

> 
>> But, I missed one point which info->base might have the garbate data instead of NULL.
>> I'll add the initialization code for info->base.
>> 	info->base = NULL;
>>
>> If you don't agree it, I'll drop this code checking the state of info->base on next patchset(v3).
> 
> Well, we should have those checks in there unless we know they're
> needed.  And if they *are* needed, we should have a good understanding
> of why they're needed, and we should be sure that we're not just
> working around some underlying problem.

You are right. Thanks for your comment and advice.

Best Regards,
Chanwoo Choi

