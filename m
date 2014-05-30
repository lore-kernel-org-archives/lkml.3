Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbaE3QF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:05:56 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:34566 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaE3QFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:05:55 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: migueloliv@gmail.com
In-Reply-To: <20140530160121.GB10682@kroah.com>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
	<20140530160121.GB10682@kroah.com>
Date: Fri, 30 May 2014 17:05:54 +0100
X-Google-Sender-Auth: 1cqR_Ot8jIwuwYQ5UCoD_aExjII
Message-ID: <CAMGgR5tjjEXpyOyo8NwT+OSXqGhD1_6jk20AvJ8XAP-5p7z_kg@mail.gmail.com>
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
From: Miguel Oliveira <cmroliv@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?R8O8bMWfYWggS8O2c2U=?= <gulsah.1004@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, pali.rohar@gmail.com,
        =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg should I make a patch for the whitespace while you are
considering in remove the driver?

Regards

2014-05-30 17:01 GMT+01:00 Greg KH <gregkh@linuxfoundation.org>:
> On Fri, May 30, 2014 at 11:27:13AM +0100, Miguel Oliveira wrote:
>> Creating this patch for the Eudyptula Challenge.
>> Replaced msleep() for a delay < 20ms with a usleep_range() between 10000us and 15000us.
>> Also inserted a blank line after adeclaration.
>
> As you are doing 2 different things in one patch, please break this up
> into two different patches.  Remember, each patch can only do 1 thing.
>
> That also lets us argue about the msleep() change, while I take your
> whitespace fix :)
>
> thanks,
>
> greg k-h
