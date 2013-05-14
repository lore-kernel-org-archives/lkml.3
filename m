Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3ENItS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:49:18 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:50731 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab3ENItP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:49:15 -0400
MIME-Version: 1.0
In-Reply-To: <1368097688-17858-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368097688-17858-1-git-send-email-fabio.baltieri@linaro.org>
Date: Tue, 14 May 2013 10:49:14 +0200
Message-ID: <CACRpkdYXAB03=bqAQ8OZ8wZ7Q9j+LwH-Uwtijw49OjXt70yiXQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: ab8500-sysctrl: Always enable pm_power_off handler
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:08 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> AB8500 sysctrl driver implements a pm_power_off handler, but that is
> currently not registered until a specific platform data field is
> enabled.
>
> This patch drops the platform data field and always registers
> ab8500_power_off if no other pm_power_off handler was defined before,
> and also introduces the necessary cleanup code in the driver's remove
> function.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
