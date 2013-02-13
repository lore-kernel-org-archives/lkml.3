Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171Ab3BMWsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:48:43 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:34921 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751494Ab3BMWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:48:42 -0500
Date: Wed, 13 Feb 2013 23:48:29 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, fabio.porcedda@gmail.com, JM.Lin@atmel.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/8] watchdog/at91sam9_wdt: Remove at91wdt_private and add at91wdt_drvdata struct
Message-ID: <20130213224829.GD7867@spo001.leaseweb.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com> <1359702386-21284-3-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359702386-21284-3-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wenyou,

> Remove the global variable at91wdt_private, add the struct at91wdt_drvdata
> as a substitute, and set it as the driver data of the at91wdt_wdd.

I rather have this after the conversion of the watchdog to the new framework.

Kind regards,
Wim.

