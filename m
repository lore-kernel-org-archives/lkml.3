Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaFXDok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 23:44:40 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40218 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaFXDoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 23:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <53A86C63.7020103@broadcom.com>
References: <1403523498-3035-1-git-send-email-sachin.kamat@samsung.com>
	<53A86C63.7020103@broadcom.com>
Date: Tue, 24 Jun 2014 09:14:38 +0530
X-Google-Sender-Auth: P5stivOLSkgmENLyhpZSW7jFyrw
Message-ID: <CAK5sBcExS2pLY-NxrxMieh6B1K9AmPgUu8Vv0AJUZsjNcCLG9A@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: bcm281xx: Staticize bcm281xx_pinctrl_probe
From: Sachin Kamat <sachin.kamat@samsung.com>
To: Sherman Yin <syin@broadcom.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sherman,

On Mon, Jun 23, 2014 at 11:35 PM, Sherman Yin <syin@broadcom.com> wrote:
> Hi Sachin,
>
> Looks good, thanks.  How did you come across the need for this change?

Thanks for the review. Sparse threw up a warning while doing a regular build.

Regards,
Sachin.
