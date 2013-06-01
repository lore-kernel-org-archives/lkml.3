Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab3FACzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 22:55:38 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:57611 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab3FACza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 22:55:30 -0400
MIME-Version: 1.0
In-Reply-To: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
References: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
Date: Fri, 31 May 2013 19:55:29 -0700
X-Google-Sender-Auth: OMOpxzWEChYXAaLuRN5lvxd0XsQ
Message-ID: <CALiw-2FddAk=4ykYcrc1_EimyZC7-qq2rwNuJCuvU_GayE9CZA@mail.gmail.com>
Subject: Re: [PATCH 0/3] usb: misc: usb3503: Fix up usb3503 driver
From: Olof Johansson <olofj@chromium.org>
To: Julius Werner <jwerner@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dongjin Kim <tobetter@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/31 Julius Werner <jwerner@chromium.org>:
> This patch set contains a few minor changes to the recently added SMSC
> USB3503 driver. It addresses issues that seem to be either left-over
> stopgaps from an early development stage or board-specific hacks,
> changing them to defaults that should be most sane and useable for all
> platforms that contain this chip.
>
> Julius Werner (3):
>   usb: misc: usb3503: Fix up whitespace
>   usb: misc: usb3503: Remove hardcoded disabling of ports 2 and 3
>   usb: misc: usb3503: Remove 100ms sleep on reset, conform to data
>     sheet
>
>  drivers/usb/misc/usb3503.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)

Series:

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
