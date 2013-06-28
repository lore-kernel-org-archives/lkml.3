Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3F1Dbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:31:39 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:47813 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3F1Dbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:31:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130627193138.GB30433@spo001.leaseweb.com>
References: <1370167987-14252-1-git-send-email-anish198519851985@gmail.com>
	<20130627193138.GB30433@spo001.leaseweb.com>
Date: Fri, 28 Jun 2013 09:01:36 +0530
Message-ID: <CAK7N6vo6u74o4Bz3P6Nxr8vHxbV2Z41eGC1Z9yYjcZBTy_i_CQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC]Watchdog:core: constant pinging until userspace
 timesout when delay very less
From: anish singh <anish198519851985@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-watchdog@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 1:01 AM, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Anish,
>
>> Certain watchdog drivers use a timer to keep kicking the watchdog at
>> a rate of 0.5s (HZ/2) untill userspace times out.They do this as
>> we can't guarantee that watchdog will be pinged fast enough
>> for all system loads, especially if timeout is configured for
>> less than or equal to 1 second(basically small values).
>>
>> As suggested by Wim Van Sebroeck & Guenter Roeck we should
>> add this functionality of individual watchdog drivers in the core
>> watchdog core.
>
> Have you considered the effect this change has on all watchdog drivers
> that don't need a timer?
No,I will drop this patch.
>
> Kind regards,
> Wim.
>
