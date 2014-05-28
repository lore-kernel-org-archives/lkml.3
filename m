Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaE1Xf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:35:59 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:47446 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaE1Xf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:35:57 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.151.95]
In-Reply-To: <20140528233647.GB3580@kroah.com>
References: <1401319428-20798-1-git-send-email-c@24.io>
	<1401319428-20798-2-git-send-email-c@24.io>
	<20140528233647.GB3580@kroah.com>
Date: Wed, 28 May 2014 16:35:57 -0700
Message-ID: <CADadk9EJqf=zGTMnJiP27uKvSzkjTUfow8xWr=Qm9RXv1C-mFA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Staging: rtl8192u: r8192U_wx.c Various Code cleanups
 and code-style additions
From: Chaitanya Hazarey <c@24.io>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ksenia Ragiadakou <burzalodowa@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok will send a new one out soon.

Thanks for looking into this and sorry about the repetition.

Chaitanya

On Wed, May 28, 2014 at 4:36 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, May 28, 2014 at 04:23:48PM -0700, Chaitanya Hazarey wrote:
>> Removed dead code
>> Deleted stray newlines
>> Added newlines for better code readability
>
> These should all be broken up into individual patches.
>
> Remember, each patch should just do _one_ thing.
>
> thanks,
>
> greg k-h
