Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199Ab3BMXPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:15:32 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:34952 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752342Ab3BMXPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:15:31 -0500
Date: Thu, 14 Feb 2013 00:15:22 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, fabio.porcedda@gmail.com, JM.Lin@atmel.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/8] watchdog/at91sam9_wdt: Adjust the options of watchdog_info
Message-ID: <20130213231522.GH7867@spo001.leaseweb.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com> <1359702386-21284-5-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359702386-21284-5-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wenyou,

> Since the Watchdog Timer Mode Register can be only written only once,
> so the watchdog_info shall not support WDIOF_SETTIMEOUT
> and WDIOF_MAGICCLOSE options, remove them.

Ik you keep using the timer, then you don't have to remove this.

Kind regards,
Wim.

