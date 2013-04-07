Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161278Ab3DGBE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 21:04:26 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31092 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598Ab3DGBEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 21:04:25 -0400
X-Spam-Score: -100.8
Message-ID: <5160C5FB.8030409@asianux.com>
Date: Sun, 07 Apr 2013 09:03:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: airlied@linux.ie, bskeggs@redhat.com, airlied@redhat.com,
        dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/gpu/drm/nouveau: remove erroneous semicolon
References: <51529E77.2010906@asianux.com> <515BE1E7.7070905@asianux.com>
In-Reply-To: <515BE1E7.7070905@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg KH:

  when you have time, can you help to check this patch whether OK ?

  thanks.

gchen.

On 2013年04月03日 16:01, Chen Gang wrote:
> Hello maintainers:
> 
>   when you have time, please help to check this patch whether is OK.
> 
>   thanks.
> 
> gchen.
> 
> 
> On 2013年03月27日 15:23, Chen Gang wrote:
>>
>>   need remove semicolon, or always return true.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  drivers/gpu/drm/nouveau/nv50_display.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
>> index 7f0e6c3..1ddc03e 100644
>> --- a/drivers/gpu/drm/nouveau/nv50_display.c
>> +++ b/drivers/gpu/drm/nouveau/nv50_display.c
>> @@ -479,7 +479,7 @@ nv50_display_flip_wait(void *data)
>>  {
>>  	struct nv50_display_flip *flip = data;
>>  	if (nouveau_bo_rd32(flip->disp->sync, flip->chan->addr / 4) ==
>> -					      flip->chan->data);
>> +					      flip->chan->data)
>>  		return true;
>>  	usleep_range(1, 2);
>>  	return false;
>>
> 
> 


-- 
Chen Gang

Asianux Corporation
