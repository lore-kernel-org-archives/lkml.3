Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3KCSJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 13:09:19 -0500
Received: from mail.active-venture.com ([67.228.131.205]:49457 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3KCSJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 13:09:18 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5276914C.3010803@roeck-us.net>
Date: Sun, 03 Nov 2013 10:09:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Wim Van Sebroeck <wim@iguana.be>
CC: Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/3] watchdog: at91sam9_wdt: avoid spurious watchdog reset
 during init
References: <1383501164-8111-1-git-send-email-b.brezillon@overkiz.com> <1383501164-8111-3-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1383501164-8111-3-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 09:52 AM, Boris BREZILLON wrote:
> Use the min_heartbeat value instead of the calculated heartbeat value for
> the first watchdog reset to avoid spurious watchdog reset.
>
> Resetting the watchdog counter during init might lead to a watchdog fault
> reset because the watchdog counter has to be running for at least
> min_heartbeat.
>
> Resetting the watchdog counter after heartbeat might lead to a watchdog
> timeout reset because the watchdog counter is running for more than
> max_heartbeat time.
>
> Using min_heartbeat instead of heartbeat does not guarantee that the
> watchdog won't trigger a reset, but at least it reduces the chances to be
> in such a case.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>


