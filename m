Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3LMJez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:34:55 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45004 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3LMJex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:34:53 -0500
MIME-Version: 1.0
In-Reply-To: <1386421734-10240-3-git-send-email-alexandre.belloni@free-electrons.com>
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1386421734-10240-3-git-send-email-alexandre.belloni@free-electrons.com>
Date: Fri, 13 Dec 2013 10:34:52 +0100
Message-ID: <CACRpkdYwwrBJGg_Jw8uVJ5goyKRhfbQEOcnn-BHm5TQvWTFiNg@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: at91: implement at91_pinconf_dbg_show
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
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

> This allows to get the pin configuration by using debugfs. On my system:
>  # cat /sys/kernel/debug/pinctrl/pinctrl.3/pinconf-pins
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Patch applied with Nicolas' ACK.

Yours,
Linus Walleij
