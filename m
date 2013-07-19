Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419Ab3GSNLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:11:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55671 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759922Ab3GSNLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:11:03 -0400
Message-ID: <51E93ADA.3010402@ti.com>
Date: Fri, 19 Jul 2013 16:10:50 +0300
From: Illia Smyrnov <x0194613@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/2] Input: omap-keypad: Cleanup - remove hardcoded values
 and IRQ enabling/disabling
References: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
In-Reply-To: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.193]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 04:03 PM, Illia Smyrnov wrote:
> From: Illia Smyrnov <illia.smyrnov@ti.com>
>
> Replace unclear hardcoded values with bit field and remove
> unnecessary IRQ enabling/disabling.
>
> Based on top of v3.10-rc1.

Sorry, it is typo here. Based on v3.11-rc1.

>
> Tested on OMAP4 SDP.
>
> Illia Smyrnov (2):
>    Input: omap-keypad: Cleanup - use bitfiled instead of hardcoded
>      values
>    Input: omap-keypad: Cleanup - remove unnecessary IRQ
>      enabling/disabling
>
>   drivers/input/keyboard/omap4-keypad.c |   40 ++++++++++++--------------------
>   1 files changed, 15 insertions(+), 25 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
