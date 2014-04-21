Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaDUFXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:23:23 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:46624 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaDUFXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <201404191730.54400.arnd@arndb.de>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<53518FAC.8020504@zytor.com>
	<201404191730.54400.arnd@arndb.de>
Date: Mon, 21 Apr 2014 13:23:19 +0800
X-Google-Sender-Auth: GRO46wp9UEIuKwNmE18K6tB8cS0
Message-ID: <CAFiDJ5-PiUWetRMp65VTo4pvZM65r3WBjCZVWmxW0XnqAyO-GA@mail.gmail.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 11:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 April 2014, H. Peter Anvin wrote:
>> Did the generic headers ever get updated to match Linus' guidance that
>> any new architecture ports should use a 64-bit time_t?
>
> No, unfortunately not. With my rule that every architecture that gets
> added needs to clean up asm-generic some more, to make it easier to add
> the next one, we should probably do for nios2.
>
>         Arnd

Can you give me the documentation on this new guidance and point me
any architecture have implemented this?
Thanks.

Ley Foon
