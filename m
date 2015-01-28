Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbbA1Chz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:37:55 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:52329 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761399AbbA1Chs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:37:48 -0500
MIME-Version: 1.0
In-Reply-To: <20150125113959.GA22997@kroah.com>
References: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
	<1421546666-21461-2-git-send-email-mathieu.poirier@linaro.org>
	<20150125113959.GA22997@kroah.com>
Date: Tue, 27 Jan 2015 19:37:47 -0700
Message-ID: <CANLsYkyQydrVR1ukr6MW8uzn4C_rkext3ZnbY5PUMA=Uo416Ww@mail.gmail.com>
Subject: Re: [PATCH 1/4] staging: vt6655: correcting function declaration
 sparse error
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 January 2015 at 04:39, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Jan 17, 2015 at 07:04:23PM -0700, mathieu.poirier@linaro.org wrote:
>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> mpoirier@t430:~/work/kernel1$ make C=1 M=drivers/staging/vt6655/
>>   LD      drivers/staging/vt6655/built-in.o
>>   CHECK   drivers/staging/vt6655/device_main.c
>> drivers/staging/vt6655/device_main.c:1672:5: warning: symbol 'vnt_init' was not declared. Should it be static?
>>   CC [M]  drivers/staging/vt6655/device_main.o
>>
>> Function @vnt_init is only called by @vt6655_probe, in turn is declared "static".
>> As sparse suggest, @vnt_init should very likely be declared static as well.  At
>> least nothing in the file indicate that it should be otherwise.
>>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> ---
>>  drivers/staging/vt6655/device_main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> This whole series does not apply to my staging-next branch, of
> staging.git, please refresh against it and resend if it is still needed
> (hint, I don't think they all are...)

Turns out none of them are necessary anymore.

Regards,
Mathieu

>
> thanks,
>
> greg k-h
