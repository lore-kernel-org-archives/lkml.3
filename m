Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3HLNEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:04:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:44197 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab3HLNEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:04:35 -0400
Message-ID: <5208DD60.7080402@linutronix.de>
Date: Mon, 12 Aug 2013 15:04:32 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] clocksource: add an "menu" item to Kconfig
References: <1375873017-30625-1-git-send-email-bigeasy@linutronix.de> <520273FB.3030103@linaro.org> <52027623.20807@linutronix.de> <52027CCD.3060609@linaro.org> <5208DB43.6030404@linaro.org>
In-Reply-To: <5208DB43.6030404@linaro.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 02:55 PM, Daniel Lezcano wrote:
> Sebastian,

Hi Daniel,

> instead of adding a menu item in the Kconfig, is it possible to have
> this Kconfig PCI board support to select the right driver ?

I decided to go with only with "tristate" so it does not pop up in
Kconfig and will be selected by the MFD/PCI driver. Is this what you
have in mind?

> Thanks
>   -- Daniel

Sebastian
