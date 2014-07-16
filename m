Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622AbaGPRRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:17:19 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55317 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209AbaGPRRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:17:14 -0400
Date: Wed, 16 Jul 2014 10:17:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Kamil Debski <k.debski@samsung.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, t.figa@samsung.com,
        m.szyprowski@samsung.com, tklauser@distanz.ch,
        linux-pwm@vger.kernel.org, varkabhadram@gmail.com
Subject: Re: [PATCH v5] hwmon: pwm-fan: Add pwm-fan driver
Message-ID: <20140716171709.GA10548@roeck-us.net>
References: <1405525602-30563-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405525602-30563-1-git-send-email-k.debski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 05:46:42PM +0200, Kamil Debski wrote:
> The pwm-fan driver enables control of fans connected to PWM lines.
> This driver uses the PWM framework, so it is compatible with all
> PWM devices that provide drivers through the PWM framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Reviewed-by: Varka Bhadram <varkabhadram@gmail.com>
> Reviewed-by: Tobias Klauser <tklauser@distanz.ch>

Applied to -next, after fixing up the alignment at
devm_hwmon_device_register_with_groups.

Thanks,
Guenter
