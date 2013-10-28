Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3J1OJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:09:21 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44875 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab3J1OJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:09:19 -0400
Message-ID: <526E700A.7020106@synopsys.com>
Date: Mon, 28 Oct 2013 19:39:14 +0530
From: Vineet Gupta <vineetg76@gmail.com>
Organization: Synopsys
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: export symbol for pm_power_off in reset.c
References: <526DDEDB.4030503@asianux.com>
In-Reply-To: <526DDEDB.4030503@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 09:19 AM, Chen Gang wrote:
> Need export symbol for it, or can not pass compiling, the related error
> with allmodconfig: 
> 
>     MODPOST 2994 modules
>   ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
>   ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Applied for 3.13

Thx,
-Vineet
