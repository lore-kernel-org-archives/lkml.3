Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3G2B2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 21:28:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:2006 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3G2B2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 21:28:36 -0400
Message-ID: <51F5C504.6040504@huawei.com>
Date: Mon, 29 Jul 2013 09:27:32 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>,
        "'Luis Henriques'" <luis.henriques@canonical.com>
Subject: Re: [PATCH] video: remove unused variable dev
References: <1374919513-15356-1-git-send-email-wangkefeng.wang@huawei.com> <009601ce8bf5$e88bfda0$b9a3f8e0$@samsung.com>
In-Reply-To: <009601ce8bf5$e88bfda0$b9a3f8e0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29 8:52, Jingoo Han wrote:
> On Saturday, July 27, 2013 7:05 PM, Kefeng Wang wrote:
>>
>> Due to commit: e21d2170f [video: remove unnecessary platform_set_drvdata()],
>> variable dev is unused, so remove it.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>  drivers/video/vga16fb.c | 1 -
>>  1 file changed, 1 deletion(-)
> 
> CC'ed Luis Henriques.
> 
> 
> Hi Kefeng Wang,
> 
> The same patch was submitted by Luis Henriques 2 weeks ago.
> Also, the patch was already applied by Tomi Valkeinen.
> 
> Best regards,
> Jingoo Han
> 

Thanks for your reply, I got it, so ignore it.

>>
>> diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
>> index 830ded4..2827333 100644
>> --- a/drivers/video/vga16fb.c
>> +++ b/drivers/video/vga16fb.c
>> @@ -1265,7 +1265,6 @@ static void vga16fb_imageblit(struct fb_info *info, const struct fb_image *image
>>
>>  static void vga16fb_destroy(struct fb_info *info)
>>  {
>> -	struct platform_device *dev = container_of(info->device, struct platform_device, dev);
>>  	iounmap(info->screen_base);
>>  	fb_dealloc_cmap(&info->cmap);
>>  	/* XXX unshare VGA regions */
>> --
>> 1.8.2.2
> 
> 
> 
> 


