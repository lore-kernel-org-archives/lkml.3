Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaBND0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:26:13 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:38554 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaBND0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:26:11 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402130000110.11689@chino.kir.corp.google.com>
References: <000001cf288b$41699f40$c43cddc0$%yang@samsung.com>
	<alpine.DEB.2.02.1402130000110.11689@chino.kir.corp.google.com>
Date: Fri, 14 Feb 2014 11:26:09 +0800
Message-ID: <CAL1ERfOO873hUHkqw-DsCJ-Lr=Dw_GUZiw0OYrbgrk4CvegUSA@mail.gmail.com>
Subject: Re: [PATCH] staging: android: lowmemorykiller: set TIF_MEMDIE before
 send kill sig
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Weijie Yang <weijie.yang@samsung.com>, gregkh@linuxfoundation.org,
        anton.vorontsov@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 4:00 PM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 13 Feb 2014, Weijie Yang wrote:
>
>> Set TIF_MEMDIE tsk_thread flag before send kill signal to the
>> selected thread. This is to fit a usual code sequence and avoid
>> potential race issue.
>>
>
> Ok!
>
>> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
>> ---
>>  drivers/staging/android/lowmemorykiller.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>  mode change 100644 => 100755 drivers/staging/android/lowmemorykiller.c
>>
>
> That's bad, we'll want to keep this file with permissions of 0644.

I will remove this annoying mode change, and resend this patch.

Thanks!
