Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaEZE6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:58:00 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:38676 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaEZE56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:57:58 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.239.233]
In-Reply-To: <20140526005151.GB3129@kroah.com>
References: <1401064618-29405-1-git-send-email-c@24.io>
	<20140526005151.GB3129@kroah.com>
Date: Sun, 25 May 2014 21:57:58 -0700
Message-ID: <CADadk9H23TDT8v7urK805s106ZAEpuKhz2Zu04YnFOAxkQt_YA@mail.gmail.com>
Subject: Re: [PATCH] Staging: Silicom: bpctl_mod.c & bypass.c: Adding blank lines
From: Chaitanya Hazarey <c@24.io>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chad Williamson <chad@dahc.us>, michael.banken@mathe.stud.uni-erlangen.de,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On its way.

Chaitanya

On Sun, May 25, 2014 at 5:51 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, May 25, 2014 at 05:36:58PM -0700, Chaitanya Hazarey wrote:
>> Added a blank line after declarations in many places to fix the following warning issued by checkpatch.pl:
>
> Always wrap your lines at 72 columns, like git asks you to when you type
> in the commit message.
>
>> WARNING: Missing a blank line after declarations
>>
>> The reason why it was not applying clean against Greg's tree was that bpctl_mod.c had changed in the functions which are a part of this patch.
>
> This doesn't belong as part of the changelog, right?  Please resend and
> put it below the --- line, if you want to.
>
> Can you redo this with the changelog fixed up please?
>
> thanks,
>
> greg k-h
