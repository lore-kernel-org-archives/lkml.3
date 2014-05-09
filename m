Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbaEIWXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 18:23:30 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:45142 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbaEIWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 18:23:28 -0400
MIME-Version: 1.0
In-Reply-To: <1399560990-1402858-11-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-11-git-send-email-arnd@arndb.de>
From: Mark Roszko <mark.roszko@gmail.com>
Date: Fri, 9 May 2014 18:23:07 -0400
Message-ID: <CAJjB1qKWDN8dThK+P6VT40_F1t3b5_EOgfY0PFOCbsQ66XNFXA@mail.gmail.com>
Subject: Re: [PATCH] i2c/nuc900: fix ancient build error
To: Arnd Bergmann <arnd@arndb.de>
Cc: "<linux-arm-kernel@lists.infradead.org> mailing list" 
	<linux-arm-kernel@lists.infradead.org>,
        Baruch Siach <baruch@tkos.co.il>, Wan ZongShun <mcuos.com@gmail.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"[PATCH] NUC900: patch for implement clk_get_rate"
https://lkml.org/lkml/2010/6/15/147

This patch would have fixed the apbfreq not being a real struct member
and would also explain why clk_get_rate is called without using it's
return value in the line above what you have.

>From 2010, so it got dropped somewhere and ignored/abandoned
