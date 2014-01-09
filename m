Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbaAISuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:50:08 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44151 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaAISuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:50:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140109183909.GA10563@kroah.com>
References: <1388425244-10017-1-git-send-email-jdb@sitrep3.com> <20140109183909.GA10563@kroah.com>
From: =?UTF-8?B?Sm9lIEJvcsSh?= <jdb@sitrep3.com>
Date: Thu, 9 Jan 2014 18:49:39 +0000
X-Google-Sender-Auth: QGlF2J4By0OJxGeYMHkL-fRXjNQ
Message-ID: <CAFFYk1WCjOt4ftS30ZWVkYLjqxC-CBtbp3OeJ2HDinu4gu_d2w@mail.gmail.com>
Subject: Re: your mail
To: Greg KH <gregkh@linuxfoundation.org>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I'll re do them tonight.

I didn't do the changes as root, I sent them from my server as it has SMTP out.

Thanks

Regards,
Joseph David Borġ
http://www.jdborg.com


On 9 January 2014 18:39, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 30, 2013 at 05:40:44PM +0000, Joe Borg wrote:
>> >From 6d9f6446434c4021cc9452e31c374ac50e08f0f9 Mon Sep 17 00:00:00 2001
>> From: Joe Borg <root@josephb.org>
>
> This isn't matching your "from:" line on your email, why should I trust
> it?
>
> And doing kernel work as 'root'?  That's not a good idea for lots of
> reasons...
>
>> Date: Mon, 30 Dec 2013 15:35:08 +0000
>> Subject: [PATCH 62/62] DAS1800: Fixing error from checkpatch.
>>
>> Fixed pointer typeo; foo * bar should be foo *bar.
>>
>> Signed-off by Joe Borg <root@josephb.org>
>
> What happened to your Subject:?
>
> And why is the whole git header in the email, please use git send-email
> so that I don't have to hand-edit the body of the email to apply it.
>
> Can you please fix this up and resend?
>
> thanks,
>
> greg k-h
