Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3J3GYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:24:33 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34454 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3J3GYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:24:31 -0400
MIME-Version: 1.0
In-Reply-To: <8F7F1A3C-949F-4718-9FD5-E35C1B78E1D9@holtmann.org>
References: <CABgQ-Ti0aaxqVGF0R-huQur=EGCTyXM0w-gyz9TenC=msucJqA@mail.gmail.com>
	<1383053609-2895-1-git-send-email-changbin.du@gmail.com>
	<8F7F1A3C-949F-4718-9FD5-E35C1B78E1D9@holtmann.org>
Date: Wed, 30 Oct 2013 14:24:30 +0800
Message-ID: <CABgQ-TgWsX3_86BGdxiJ+32y_8eZ7GXyderUpE9A3mubypBeSw@mail.gmail.com>
Subject: Re: [PATCH v3] dynamic_debug: add wildcard support to filter files/functions/modules
From: Changbin Du <changbin.du@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jason Baron <jbaron@akamai.com>, Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/30 Marcel Holtmann <marcel@holtmann.org>:
> Hi Changbin,
>
>> This patch add wildcard '*'(matches zero or more characters) and '?'
>> (matches one character) support when qurying debug flags.
>>
>> Now we can open debug messages using keywords. eg:
>> 1. open debug logs in all usb drivers
>>    echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
>> 2.  open debug logs for usb xhci code
>>    echo "file *xhci* +p" > <debugfs>/dynamic_debug/control
>
> and this should have a section in Documentation/dynamic-debug-howto.txt.

Yes, I will add a section to update the documentation also. Thanks for
reminding.

>
> Regards
>
> Marcel
>
