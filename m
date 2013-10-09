Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3JIGkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:40:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38449 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3JIGku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:40:50 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-bc-5254fa3876b0
Message-id: <5254FA36.2040803@samsung.com>
Date: Wed, 09 Oct 2013 15:39:50 +0900
From: "sangjung.woo" <sangjung.woo@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        sangjung.woo@samsung.com
Subject: Re: [PATCH] rtc: rtc-puv3: use dev_dbg() instead of pr_debug()
References: <1381297783-24658-1-git-send-email-sangjung.woo@samsung.com>
 <1381299606.2040.21.camel@joe-AO722>
In-reply-to: <1381299606.2040.21.camel@joe-AO722>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkQNfiV0iQwb734hZLLl5ltzh44xu7
	xez7j1ksLu+aw2axv7OD0WLBnhIHNo89E0+yeTzea+nxZdU1Zo++LasYPabP+8nk8XmTXABb
	FJdNSmpOZllqkb5dAlfGjo0XGQumsVdcndDK3sB4j7WLkYNDQsBE4tK9jC5GTiBTTOLCvfVs
	XYxcHEICSxkljkx7zgSRMJH4d2MaVGI6o8SMxZ9ZIZzXjBIrt89lB6niFdCSWNy7igXEZhFQ
	lfj9/BaYzSagL/Fx+XJmEFtUIExiybfHbBD1ghI/Jt9jAblCREBR4u4WfpCZzALLGCXu37jL
	BBIXFnCXWNJqBFIuJJAv0bi+D+wgTgFDid7/j8FsZgFriZWTtjFC2PISm9e8ZQaZIyFwjl1i
	/pd/UPcISHybfIgF4mNZiU0HmCEek5Q4uOIGywRGsVlILpqFZOwsJGMXMDKvYhRNLUguKE5K
	LzLWK07MLS7NS9dLzs/dxAiMuNP/nvXvYLx7wPoQYzLQyonMUqLJ+cCIzSuJNzQ2M7IwNTE1
	NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD49wnrJOS902RuJpgsumN
	6PsUft+NO2fu+pnUpnzmu2wzx5c1ZZfStklcPCT7c6/g9i01Mf/nz+xd7ymokveBd9+/KUYl
	eoVG97ksEyZvVam2zTklKPz3IecJqVcc4asKg61VFLVWSXzXZG7491Zk2bbegJKora1aRb3x
	/Ir9zXdOVDmX183uV2Ipzkg01GIuKk4EAOKFwvjOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQV2LXyFBBq1XBCyWXLzKbnHwxjd2
	i9n3H7NYXN41h81if2cHo8WCPSUObB57Jp5k83i819Ljy6przB59W1Yxekyf95PJ4/MmuQC2
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGTs2XmQsmMZecXVCK3sD4z3W
	LkZODgkBE4l/N6axQdhiEhfurQeyuTiEBKYzSsxY/JkVwnnNKLFy+1x2kCpeAS2Jxb2rWEBs
	FgFVid/Pb4HZbAL6Eh+XL2cGsUUFwiSWfHvMBlEvKPFj8j2gGg4OEQFFibtb+EFmMgssY5S4
	f+MuE0hcWMBdYkmrEUi5kEC+ROP6PiYQm1PAUKL3/2Mwm1nAWmLlpG2MELa8xOY1b5knMArM
	QrJhFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjuhn0jsYVzVYHGIU4GBU
	4uF9wB8SJMSaWFZcmXuIUYKDWUmEN28hUIg3JbGyKrUoP76oNCe1+BBjMjAAJjJLiSbnA5NN
	Xkm8obGJmZGlkbmhhZGxOWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw9mQeu+9SviiN
	TUOS51VByqHY6GcdElYiStMtBGZbKSqbKRw77Lp0SvcTzRn5TZ4vGuOjhS8/yG55/n7Hug+P
	1+7qiZx7lnlL3fpztgsuzZ/5WvuPrKLdxeLvO5TOPVfMYnv9TaQoctKsSO+N3PNMVr1w2Hqg
	q5OdaVbHJPZJAg2f0jSXr7J6r8RSnJFoqMVcVJwIAH0h27IsAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 03:20 PM, Joe Perches wrote:
> On Wed, 2013-10-09 at 14:49 +0900, Sangjung Woo wrote:
>> Because dev_*() are used along with pr_debug() function in this code,
>> the debug message is not tidy. This patch converts from pr_debug() to
>> dev_dbg() since dev_*() are encouraged to use in device driver code.
> []
>> diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
> []
>> @@ -57,7 +57,7 @@ static void puv3_rtc_setaie(int to)
>>   {
>>   	unsigned int tmp;
>>   
>> -	pr_debug("%s: aie=%d\n", __func__, to);
>> +	dev_dbg(dev, "%s: aie=%d\n", __func__, to);
> Does this compile?
>
>
Oops! I did not add my local modification into the patch.
The function parameters should be modified as below.

-static void puv3_rtc_setaie(int to)
+static void puv3_rtc_setaie(struct device *dev, int to)


I will send the new one.
Thank you for your good review.

Cheers, Sangjung

