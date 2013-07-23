Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3GWGER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 02:04:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43009 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3GWGEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 02:04:15 -0400
Message-ID: <51EE1CD2.6080406@ti.com>
Date: Tue, 23 Jul 2013 11:34:02 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

  
On 7/22/2013 11:39 PM, Sebastian Andrzej Siewior wrote:

> This patch renames the type struct from ti81xx_driver_data to
> am33xx_driver_data since it is not used for ti81xx anymore. The EOI
> member is also removed since the am33xx SoC does not have such register.
> The interrupt is acknowledged by writting into the stat register.
>

AM335X TRM Section 16.6.5 and 16.7.5 describes about EOI registers.
Its at offset 0x24. Or is it that the interrupts are acknowledged even
without writing to eoi register?

-- 
-George

