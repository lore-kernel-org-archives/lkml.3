Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3ILP2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:28:16 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55583 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3ILP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:28:13 -0400
Date: Thu, 12 Sep 2013 16:28:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Message-ID: <20130912152809.GO11227@lee--X1>
References: <1378949441-6073-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378949441-6073-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Documentation
>   From Thierry's suggestion, detailed driver description was moved to
>   'Documentation/lp3943.txt'.

Really? Why here? Do we really want 1000's of driver docs in /Documentation?

No other driver does this (intel gained from a glancing look).

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
