Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaJIKCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:02:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59703 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbaJIKCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:02:12 -0400
Date: Thu, 9 Oct 2014 11:01:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        David Paris <david.paris@st.com>, "wim@iguana.be" <wim@iguana.be>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 4/4] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20141009100115.GD3869@leverpostej>
References: <1412760810-23199-1-git-send-email-lee.jones@linaro.org>
 <1412760810-23199-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412760810-23199-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-type");

This wasn't mentioned in the binding. A comment mentioned "type", but
there was no explicit mention of "syscfg-type" in reg-names.

Mark.
