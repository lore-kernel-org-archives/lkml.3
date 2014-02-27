Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaB0BKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:10:15 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:36027 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaB0BKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:10:13 -0500
MIME-Version: 1.0
In-Reply-To: <2283771.eQo0eImXtS@vostro.rjw.lan>
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com>
 <CAGf84QK75jsXdnehwDNr8g+dCvdQKQ7+bgXmsbF_YFMKKYoGGw@mail.gmail.com>
 <CAGf84QK=YDN6MHTzEEc-1rbWHyGkBSbSdobaUwXV18d++EO+eg@mail.gmail.com> <2283771.eQo0eImXtS@vostro.rjw.lan>
From: Kieran Clancy <clancy.kieran@gmail.com>
Date: Thu, 27 Feb 2014 11:39:42 +1030
Message-ID: <CAGf84Q+kHgfx6OaiEWFKs6kMmj_JiHLooeRxpXs7a64iC40zFw@mail.gmail.com>
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

On Thu, Feb 27, 2014 at 11:46 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, February 27, 2014 11:29:53 AM Kieran Clancy wrote:
>>
>> Oh, and I should add that Juan and Dennis both helped to test the
>> patch extensively.
>
> You can use Tested-by or Reported-and-tested-by for that.

Is it okay to have someone listed as both 'Reviewed-by' and
'Tested-by', or both 'Suggested-by' and 'Tested-by'?

Thank you for your help. Once I fix up these things, I will send a patch v2.

Kieran.
