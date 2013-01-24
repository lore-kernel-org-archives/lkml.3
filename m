Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3AXLol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:44:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54035 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3AXLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:44:32 -0500
Message-ID: <51011E9D.7050409@ti.com>
Date: Thu, 24 Jan 2013 12:44:29 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Input: twl6040-vibra cleanups (devm_* conversion,
 system wq)
References: <1358177678-16509-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1358177678-16509-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 01/14/2013 04:34 PM, Peter Ujfalusi wrote:
> Hi Dmitry,
> 
> Changes since v2:
> - twl4030-vibra patches are left out (they have been applied)
> - Do not use devm_input_allocate_device() in twl6040-vibra

Do you want me to resend this two patch for 3.9?

Regards,
Péter

> 
> Changes since v1:
> - Use devm_input_allocate_device()
> - swtich drivers to use system workqueue
> 
> Cover letter from v1 (resend set):
> 
> This series seams to got lost:
> https://lkml.org/lkml/2012/6/15/128
> 
> Can you take it for 3.9?
> 
> Convert the twl4030, twl6040 vibra drivers to use devm_ at probe time to clean
> up the code a bit.
> The twl6040-vibra driver needed bigger change since the ordering of the
> initialization was not correct.
> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (2):
>   Input: twl6040-vibra: Code cleanup in probe with devm_* conversion
>   input: twl6040-vibra: Use system workqueue
> 
>  drivers/input/misc/twl6040-vibra.c | 100 +++++++++++++++----------------------
>  1 file changed, 41 insertions(+), 59 deletions(-)
> 


