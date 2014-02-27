Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaB0Api (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:45:38 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:42129 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaB0Apg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <1670100.tBHUbYFGo0@vostro.rjw.lan>
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com> <1670100.tBHUbYFGo0@vostro.rjw.lan>
From: Kieran Clancy <clancy.kieran@gmail.com>
Date: Thu, 27 Feb 2014 11:15:05 +1030
Message-ID: <CAGf84QK75jsXdnehwDNr8g+dCvdQKQ7+bgXmsbF_YFMKKYoGGw@mail.gmail.com>
Subject: Re: [PATCH] ACPI / EC: Clear stale EC events on Samsung systems
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Dennis Jansen <dennis.jansen@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:15 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, February 27, 2014 02:12:40 AM Kieran Clancy wrote:
>> Signed-off-by: Kieran Clancy <clancy.kieran@gmail.com>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> Signed-off-by: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
>> Signed-off-by: Dennis Jansen <dennis.jansen@web.de>
>
> There are too many sign-offs under this patch.  I suppose some of them
> should be Acked-by or Reviewed-by.
>
> Are you the author?

Sorry about that, I wasn't sure of the best way to acknowledge the
people involved.

I am the primary author, but I based the loop which calls
acpi_ec_query_unlocked() on a patch by Lan Tianyu. Juan provided the
initial idea (userspace workaround), and Dennis and Lan Tianyu
reviewed and suggested some changes to the code.

What would you usually do this kind of situation?

I suppose I could put something such as:

Signed-off-by: Kieran Clancy <clancy.kieran@gmail.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Suggested-by: Juan Manuel Cabo <juanmanuel.cabo@gmail.com>
Reviewed-by: Lan Tianyu <tianyu.lan@intel.com>
Reviewed-by: Dennis Jansen <dennis.jansen@web.de>

Would this be preferable?

Thanks,
Kieran Clancy
