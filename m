Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaEXFcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 01:32:20 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:55225 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaEXFcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 01:32:19 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.239.233]
In-Reply-To: <20140523222605.GA8839@kroah.com>
References: <1400881630-23997-1-git-send-email-c@24.io>
	<20140523222605.GA8839@kroah.com>
Date: Fri, 23 May 2014 22:32:17 -0700
Message-ID: <CADadk9EKt=X=nBuhBpnk_ZUUP0jTFGSykWeBsppUFXi-m3m4RA@mail.gmail.com>
Subject: Re: [PATCH] Staging: Silicom: bpctl_mod.c: Fixed a lot of
 checkpatch.pl warnings
From: Chaitanya Hazarey <c@24.io>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chad Williamson <chad@dahc.us>, michael.banken@mathe.stud.uni-erlangen.de,
        lorenz@badgers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Greg for looking into it,

I have resubmitted using a new email, hope that works out.

Thanks,

Chaitanya

On Fri, May 23, 2014 at 3:26 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, May 23, 2014 at 02:47:10PM -0700, Chaitanya Hazarey wrote:
>> Added a blank line after declarations in many places to fix the following warning issued by checkpatch.pl:
>>
>> WARNING: Missing a blank line after declarations
>> ---
>>  drivers/staging/silicom/bpctl_mod.c |   90 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 88 insertions(+), 2 deletions(-)
>
> Something is corrupted in this patch and it doesn't apply properly.  Can
> you resend it to yourself and try to figure out what went wrong?
>
> thanks,
>
> greg k-h
