Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3LLOoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:44:07 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41489 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3LLOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:44:04 -0500
MIME-Version: 1.0
In-Reply-To: <1386421734-10240-2-git-send-email-alexandre.belloni@free-electrons.com>
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1386421734-10240-2-git-send-email-alexandre.belloni@free-electrons.com>
Date: Thu, 12 Dec 2013 15:44:03 +0100
Message-ID: <CACRpkdaA+vcwiok8_jv8tNRwgPFWeXFcd_zRs4M3rH2W4FG1Zw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: at91: initialize config parameter to 0
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 7, 2013 at 2:08 PM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:

> When passing a not initialized config parameter, at91_pinconf_get() would return
> a bogus value. Fix that by initializing it to zero before using it.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Patch applied.

Yours,
Linus Walleij
