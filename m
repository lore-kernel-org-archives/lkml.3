Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3C0Trc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:47:32 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53892 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3C0Trb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:47:31 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 27 Mar 2013 12:47:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: khali@linux-fr.org, lm-sensors@lm-sensors.org, cbou@mail.ru,
        dwmw2@infradead.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/5] ab8500: power: export abx500_res_to_temp tables
 for hwmon
Message-ID: <20130327194743.GA11086@roeck-us.net>
References: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
 <1364368412-12810-5-git-send-email-hongbo.zhang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364368412-12810-5-git-send-email-hongbo.zhang@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:13:31PM +0800, Hongbo Zhang wrote:
> This patch exports the thermistor resistance-to-temperature tables, so that the
> hwmon driver can access them, and also adds the corresponding table size
> variables.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>

Acked-by: Guenter Roeck <linux@roeck-us.net>
