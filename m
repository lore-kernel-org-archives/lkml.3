Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161254Ab3BOGwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:52:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161111Ab3BOGwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:52:23 -0500
X-AuditID: cbfee690-b7f066d00000169f-7b-511ddb21ae29
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
 <002501ce0b48$36cf28e0$a46d7aa0$%han@samsung.com>
 <1360910978.2089.3.camel@joe-AO722>
In-reply-to: <1360910978.2089.3.camel@joe-AO722>
Subject: Re: [PATCH V2 07/11] rtc: rtc-rs5c313: use pr_err() instead of printk()
Date: Fri, 15 Feb 2013 15:52:16 +0900
Message-id: <002a01ce0b48$fe36acf0$faa406d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LSKHGYDDFxSNSQ2eAiMCZIKCP+wAAD6EA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA13F27KBBrePCVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mk7eusBZsZ6+YdfcbYwPjA9YuRk4OCQETiV1tjYwQtpjEhXvr
	2boYuTiEBJYxSly/vIMdpujBuQlMEIlFjBLLt69nhnBmM0n8/XmCCaSKTUBN4suXw2AdIgLK
	EgsWfWYBKWIWmMYo8ef6c3aIjumMEh9n3QZazsHBKWAgcfmfMUiDsECAxPwPj8GaWQRUJU70
	HAW7iVfAVuLAjVesELagxI/J91hAbGYBLYnN25pYIWx5ic1r3jKDjJQQUJd49FcX4gYjiYub
	LjFDlIhI7HvxDurNZewS207JQ6wSkPg2+RALRKusxKYDzBAlkhIHV9xgmcAoMQvJ4llIFs9C
	sngWkg0LGFlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoTE1oQdjPcOWB9iTAZaP5FZSjQ5
	HxibeSXxhsbGJmYmpibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	OPn2u5itj/X5Fuz9PEt+reT/43zT9+bzXfwf7unGFFh+5q6BiveL2dvW+ctyuZw1mnjzYk6F
	SMxLvyd7lsaySJ2zMUk5dvx9KkvIxwW5284GKCfEb247++CbSOLNiYclL2S9NUp0nfv2jsTs
	Xokze/Z4xWsuvshwkO3Tipmevil/Hb/vq3i7z1SJpTgj0VCLuag4EQCx1M/zwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgK7ibdlAg5+TBSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxslbV1gLtrNXzLr7jbGB
	8QFrFyMnh4SAicSDcxOYIGwxiQv31rN1MXJxCAksYpRYvn09M4Qzm0ni788TYFVsAmoSX74c
	ZgexRQSUJRYs+swCUsQsMI1R4s/15+wQHdMZJT7Oug20g4ODU8BA4vI/Y5AGYYEAifkfHoM1
	swioSpzoOcoIYvMK2EocuPGKFcIWlPgx+R4LiM0soCWxeVsTK4QtL7F5zVtmkJESAuoSj/7q
	QtxgJHFx0yVmiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnF
	pXnpesn5uZsYwbH7THoH46oGi0OMAhyMSjy8AhKygUKsiWXFlbmHGCU4mJVEeOVuAYV4UxIr
	q1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5hW8kriDY1NzIwsjcwsjEzMzUkTVhLnZTz1JEBIID2x
	JDU7NbUgtQhmCxMHp1QDY+iXpGdRuiaZFyY2vst+nB31Krrpg8KcH7N3Z/mLGGR+ncHArrdP
	kE9eZY3u0eDLAXGPfr8z+nU5hMfp5NWw6w2HbSJSjlwPa7rYJP5sX8Kf9FK5g7oVHY0FxXrb
	5bN7vi5zeS23K+ah5Hq1R6+r+z49OvX9V9dLR1/rA7NUOh6p/7d5UHmKS4mlOCPRUIu5qDgR
	AM6jFb0hAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 15, 2013 3:50 PM, Joe Perches wrote:
> On Fri, 2013-02-15 at 15:46 +0900, Jingoo Han wrote:
> > Fixed the checkpatch warning as below:
> []
> > diff --git a/drivers/rtc/rtc-rs5c313.c b/drivers/rtc/rtc-rs5c313.c
> []
> > @@ -39,6 +39,8 @@
> >   *	1.13	Nobuhiro Iwamatsu: Updata driver.
> >   */
> >
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> >  #include <linux/module.h>
> >  #include <linux/err.h>
> >  #include <linux/rtc.h>
> > @@ -352,8 +354,7 @@ static void rs5c313_check_xstp_bit(void)
> >  		tm.tm_year 	= 2000 - 1900;
> >
> >  		rs5c313_rtc_set_time(NULL, &tm);
> > -		printk(KERN_ERR "RICHO RS5C313: invalid value, resetting to "
> > -				"1 Jan 2000\n");
> > +		pr_err("RICHO RS5C313: invalid value, resetting to 1 Jan 2000\n");
> 
> You could remove the "RICH0 RS5C313: "prefix,
> pr_fmt adds it (more or less).

OK, I will remove it.
Thank you.

Best regards,
Jingoo Han


