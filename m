Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaEZFCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:02:16 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48950 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaEZFCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <1401080234-31174-1-git-send-email-cw00.choi@samsung.com>
References: <1401080234-31174-1-git-send-email-cw00.choi@samsung.com>
Date: Mon, 26 May 2014 10:32:14 +0530
Message-ID: <CAK9yfHyOYXOVMKUpKisT4tZePh=s_Lv6h=SLOnw=1iS8NaHv7A@mail.gmail.com>
Subject: Re: [PATCH] input: gpio_keys: Add IRQF_NO_SUSPEND flag to wake-up
 from freeze state
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,


On 26 May 2014 10:27, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch add IRQF_NO_SUSPEND flag before requesting interrupt handler
> if button->wakeup is true. If ther interrupt of gpio-keys hasn't included
> IRQF_NO_SUSPEND, wouldn't wake-up from freeze state when pressing button.

Please refer to the below thread. Looks like it was similar to what
you are proposing.
http://www.spinics.net/lists/linux-input/msg28780.html

-- 
With warm regards,
Sachin
