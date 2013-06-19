Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3FSRYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:24:02 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60345 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3FSRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:23:59 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: <stern@rowland.harvard.edu>, <tony@atomide.com>, <balbi@ti.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC PATCH 2/6] mfd: omap-usb-host: Put pins in IDLE state on suspend
References: <1371650753-11452-1-git-send-email-rogerq@ti.com>
	<1371650753-11452-3-git-send-email-rogerq@ti.com>
Date: Wed, 19 Jun 2013 10:23:55 -0700
In-Reply-To: <1371650753-11452-3-git-send-email-rogerq@ti.com> (Roger
	Quadros's message of "Wed, 19 Jun 2013 17:05:49 +0300")
Message-ID: <878v26815g.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

Roger Quadros <rogerq@ti.com> writes:

> In order to support wake up from suspend use the pinctrl
> framework to put the USB host pins in IDLE state during suspend.
>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

You should use helpers for this now in the pinctrl core:

    http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173514.html

Kevin
