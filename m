Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaCZNHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:07:21 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:45196 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaCZNGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:06:19 -0400
Message-ID: <5332D0C8.5040300@cogentembedded.com>
Date: Wed, 26 Mar 2014 17:06:16 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, balbi@ti.com
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "3.9+" <stable@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: gadget: zero: Fix SuperSpeed enumeration for alternate
 setting 1
References: <1395826086-5097-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1395826086-5097-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-03-2014 13:28, Roger Quadros wrote:

> It was impossible to enumerate on a SuperSpeed (XHCI) host
> with alternate setting = 1 due to the wrongly set 'bMaxBurst'
> field in the SuperSpeed Endpoint Companion descriptor.

> Testcase:
> <host> modprobe -r usbtest; modprobe usbtest alt=1
> <device> modprobe g_zero
> plug device to SuperSpeed port on the host.

> Without this patch the host always complains like so
> "usb 12-2: Not enough bandwidth for new device state.
>   usb 12-2: Not enough bandwidth for altsetting 1"

> Bug was introduced by commit cf9a08ae in v3.9

    Please also specify that commit's summary in parens. Also, there's now an 
adopted standard way of saying this:

Fixes: <12-digit SHA ID> ("<summary line>")

> Cc: 3.9+ <stable@vger.kernel.org> # 3.9+
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

WBR, Sergei


