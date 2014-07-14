Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaGNAgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 20:36:06 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:40812 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaGNAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 20:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140714001306.GA6524@kroah.com>
References: <20140713232513.GA15486@archDesk> <20140714001306.GA6524@kroah.com>
From: Lucas Tanure <tanure@linux.com>
Date: Sun, 13 Jul 2014 21:35:40 -0300
X-Google-Sender-Auth: tR2CeCAn_Qn_-6GIckGIP161baQ
Message-ID: <CAJyon0t9zQWeuXZ6KUDqCQCiZU4wrGYPc+sCh72NBWGOFoCXxw@mail.gmail.com>
Subject: Re: [PATCH v3] staging: android: Clean up else statement from binder_send_failed_reply
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. I will do it.
4th could be the right one =p.

Thanks for your time
Cheers

--
Lucas Tanure
+55 (19) 988176559


On Sun, Jul 13, 2014 at 9:13 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Jul 13, 2014 at 08:25:13PM -0300, Lucas Tanure wrote:
>> Kernel coding style. Remove useless else statement after return.
>> Changes from v1 and v2: Fix warning for mixed declarations and code.
>> Declaration of "struct binder_transaction *next" made outside of while,
>> and initialized with NULL.
>
> Why did you initialize it with NULL?  It's not needed to do this, right?
>
> 4th time's a charm?
>
> thanks,
>
> greg k-h
