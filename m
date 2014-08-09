Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaHIRzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:55:05 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1044 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaHIRzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:55:02 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2014 13:55:00 EDT
Message-ID: <53E65EA4.6080106@xs4all.nl>
Date: Sat, 09 Aug 2014 19:47:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Suman Kumar <suman@inforcecomputing.com>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: soc_camera: soc_camera_platform.c: Fixed a Missing
 blank line coding style issue
References: <1407604952-15492-1-git-send-email-suman@inforcecomputing.com> <Pine.LNX.4.64.1408091934100.20541@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1408091934100.20541@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 07:36 PM, Guennadi Liakhovetski wrote:
> Hi Suman,
> 
> On Sat, 9 Aug 2014, Suman Kumar wrote:
> 
>>     Fixes a coding style issue reported by checkpatch.pl
> 
> Thanks for your patch. To my taste checkpatch.pl has unfortunately become 
> too noisy with meaningless / unimportant warnings like this one. Is this 
> in CodingStyle? If not, my intention is to drop this.

I don't see it being mentioned explicitly in the CodingStyle, but the coding
style follows K&R, and they put an empty line between local variables and the
start of the code. And I like it that way as well, it makes it easier to review.

If you don't want to be bothered by such patches, just delegate them to me in
patchwork, I don't mind.

Regards,

	Hans

> However, Mauro may 
> override by either taking this himself or asking me to apply this.
> 
> Thanks
> Guennadi
> 
>>
>> Signed-off-by: Suman Kumar <suman@inforcecomputing.com>
>> ---
>>  drivers/media/platform/soc_camera/soc_camera_platform.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
>> index ceaddfb..fe15a80 100644
>> --- a/drivers/media/platform/soc_camera/soc_camera_platform.c
>> +++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
>> @@ -27,12 +27,14 @@ struct soc_camera_platform_priv {
>>  static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
>>  {
>>  	struct v4l2_subdev *subdev = platform_get_drvdata(pdev);
>> +
>>  	return container_of(subdev, struct soc_camera_platform_priv, subdev);
>>  }
>>  
>>  static int soc_camera_platform_s_stream(struct v4l2_subdev *sd, int enable)
>>  {
>>  	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
>> +
>>  	return p->set_capture(p, enable);
>>  }
>>  
>> -- 
>> 1.8.2
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

