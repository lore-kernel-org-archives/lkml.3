Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3H0KNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:13:41 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:56716 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3H0KNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:13:39 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Aug 2013 06:13:38 EDT
Message-ID: <521C7A85.6000504@ti.com>
Date: Tue, 27 Aug 2013 13:08:05 +0300
From: Illia Smyrnov <illia.smyrnov@globallogic.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Illia Smyrnov <illia.smyrnov@globallogic.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 0/3] Input: omap-keypad: Wakeup capability and w/a
 for i689 errata.
References: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com>
In-Reply-To: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

could you take reviewed patches from this patchset?

Reviewed patches:
[PATCH v3 1/3] Input: omap-keypad: Enable wakeup capability for keypad.
[PATCH v3 3/3] Input: omap-keypad: Setup irq type from DT
are not depend on
[PATCH v3 2/3] Input: omap-keypad: errata i689: Correct debounce time

Thanks.

On 07/29/2013 07:45 PM, Illia Smyrnov wrote:
> This patchset adds wake up capability for the keypad and
> workaround for i689 errata.
>
> Based on top of v3.11-rc3
>
> Depends on:
>
> Input: omap-keypad: Convert to threaded IRQ
> https://patchwork.kernel.org/patch/2832920/
>
> Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded values
> https://patchwork.kernel.org/patch/2832913/
>
> Axel Haslam (1):
>    Input: omap-keypad: errata i689: Correct debounce time
>
> Illia Smyrnov (2):
>    Input: omap-keypad: Enable wakeup capability for keypad.
>    Input: omap-keypad: Setup irq type from DT
>
>   drivers/input/keyboard/omap4-keypad.c |   52 ++++++++++++++++++++++++++++++---
>   1 file changed, 48 insertions(+), 4 deletions(-)
>
