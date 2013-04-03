Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271Ab3DCQbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:31:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55581 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab3DCQbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:31:49 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 3 Apr 2013 09:31:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: khali@linux-fr.org, lm-sensors@lm-sensors.org, cbou@mail.ru,
        dwmw2@infradead.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/5] hwmon: add ST-Ericsson ABX500 hwmon driver
Message-ID: <20130403163155.GA18863@roeck-us.net>
References: <1364991492-2421-1-git-send-email-hongbo.zhang@linaro.org>
 <1364991492-2421-6-git-send-email-hongbo.zhang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364991492-2421-6-git-send-email-hongbo.zhang@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 08:18:12PM +0800, Hongbo Zhang wrote:
> Each of ST-Ericsson X500 chip set series consists of both ABX500 and DBX500
> chips. This is ABX500 hwmon driver, where the abx500.c is a common layer for
> all ABX500s, and the ab8500.c is specific for AB8500 chip. Under this designed
> structure, other chip specific files can be added simply using the same common
> layer abx500.c.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>

Acked-by: Guenter Roeck <linux@roeck-us.net>
