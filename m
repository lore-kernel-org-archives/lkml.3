Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab3LESeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:34:15 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53548 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab3LESeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:34:11 -0500
Message-ID: <52A0C71F.1070906@linaro.org>
Date: Thu, 05 Dec 2013 10:34:07 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
CC: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, olof@lixom.net,
        tglx@linutronix.de
Subject: Re: [PATCH v3 02/03] ARM: shmobile: Remove CMT, TMU and STI Kconfig
 entries
References: <20131204203818.19090.92396.sendpatchset@w520> <20131204203837.19090.96622.sendpatchset@w520>
In-Reply-To: <20131204203837.19090.96622.sendpatchset@w520>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 12:38 PM, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
>
> Now when drivers/clocksource/Kconfig has been
> updated with entires for CMT, TMU and STI
> it is safe to remove these from mach-shmobile.
>
> Also select timers per SoC via SYS_SUPPORTS_xxx.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

Looks ok to me. Sorry for all the review pain on this.

For what its worth:
Acked-by: John Stultz <john.stultz@linaro.org>


