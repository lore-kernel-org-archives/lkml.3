Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3FZO7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:59:41 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49714 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3FZO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:59:40 -0400
MIME-Version: 1.0
In-Reply-To: <1372258383-24524-1-git-send-email-jonas.jensen@gmail.com>
References: <1371549604-7201-1-git-send-email-jonas.jensen@gmail.com>
	<1372258383-24524-1-git-send-email-jonas.jensen@gmail.com>
Date: Wed, 26 Jun 2013 16:59:39 +0200
Message-ID: <CACmBeS1zRKJxQGUUDr284F=ftOK45fU4W+QT9_dz-tWc3FK+kg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: clocksource: add support for MOXA ART SoCs
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, john.stultz@linaro.org,
        tglx@linutronix.de, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de,
        Jonas Jensen <jonas.jensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have attempted to rectify with changes from all the feedback I have received.

On 26 June 2013 16:53, Jonas Jensen <jonas.jensen@gmail.com> wrote:
> This patch adds an clocksource driver for the main timer(s)
> found on MOXA ART SoCs.
>
> Changes since v2:

Unfortunately the commit message is incorrect, these are changes since v1.

Best regards,
Jonas
