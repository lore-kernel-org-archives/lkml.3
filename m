Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaEYS36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:29:58 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:60605 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaEYS35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:29:57 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.239.233]
In-Reply-To: <20140525180357.GA18332@kroah.com>
References: <1400909128-1409-1-git-send-email-c@24.io>
	<20140525180357.GA18332@kroah.com>
Date: Sun, 25 May 2014 11:29:56 -0700
Message-ID: <CADadk9FcY3Xr-0qjACXDm77qtO19xtPQ3pWDWF-8V2NJqo4UZQ@mail.gmail.com>
Subject: Re: [PATCH] Staging: Silicom: bpctl_mod.c & bypass.c: Fixed a lot of
 checkpatch.pl warnings
From: Chaitanya Hazarey <c@24.io>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chad Williamson <chad@dahc.us>, michael.banken@mathe.stud.uni-erlangen.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Greg, this is taking so long, will make this against your tree
and send it out.

Thanks for looking into this,

Chaitanya

On Sun, May 25, 2014 at 11:03 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, May 23, 2014 at 10:25:28PM -0700, Chaitanya Hazarey wrote:
>> Added a blank line after declarations in many places to fix the
>> following warning issued by checkpatch.pl:
>>
>> WARNING: Missing a blank line after declarations
>>
>> Thanks Greg K-H and Dan for the patience. Hope it works this time, I did
>> apply it against staging and it was ok.
>
>
> Hm, something is odd, it still doesn't apply properly:
>
> $ p1 < ../s1
> checking file drivers/staging/silicom/bpctl_mod.c
> Hunk #40 FAILED at 4773.
> Hunk #41 FAILED at 4821.
> ...
> Hunk #89 FAILED at 7534.
> 3 out of 89 hunks FAILED
>
> Can you refresh this against my tree again and resend?  I think we are
> out of sync here still.
>
> thanks,
>
> greg k-h
