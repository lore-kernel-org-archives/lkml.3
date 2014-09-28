Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaI1W6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 18:58:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35501 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaI1W6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 18:58:13 -0400
Message-ID: <54289267.7030905@ti.com>
Date: Sun, 28 Sep 2014 18:57:43 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Sebastian Reichel <sre@kernel.org>,
        "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] power/reset: keystone: Register with kernel restart
 handler
References: <1411779438-23127-1-git-send-email-linux@roeck-us.net> <1411779438-23127-9-git-send-email-linux@roeck-us.net>
In-Reply-To: <1411779438-23127-9-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 08:57 PM, Guenter Roeck wrote:
> Register with kernel restart handler instead of setting arm_pm_restart directly.
> 
> Move notifier registration to the end of the probe function to avoid having to
> implement error handling.
> 
> Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
Looks ok for me.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Ivan,
Can you please just test it once ? Thanks !!

Regards,
Santosh


