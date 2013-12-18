Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3LRRUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:20:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3LRRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:20:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH] watchdog: mach-moxart: add restart handler
Date: Wed, 18 Dec 2013 18:20:39 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux@roeck-us.net
References: <1387379883-16525-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1387379883-16525-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312181820.39639.arnd@arndb.de>
X-Provags-ID: V02:K0:5lBtpWiFcvw4F8whZaf2GsN/qb2NTXSjfLmcDD7JuoP
 UtL6zLB10lpcmiVZYYVSEhsOOtpgry886b//0IUaO0PE1kxG6v
 LTqXCbTyrJXr3aPMX8/bhPoea9+UTBrDnQxnR2BeVVsW3RbHq/
 GvM1DzF4/mczCW+L1/nguItizIDwRZsil2fUFx7WBphCwmBBm3
 dfDyixm+3oYXXg3av/fJYJ4dfJnWZygHhd5JGOZGyfRVqLEX0x
 vXTBJb1mjs2ynHiMd1DCOuTwlYxJ9VW76AjIczt6Fpi+FKN4bi
 NohtNnn3ErX5u9htrBrXzkjWE8zbvUSKPYa1HVhpUZDFrRdQ82
 fPiGNRCME8rdULncOM9A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 December 2013, Jonas Jensen wrote:
> mach-moxart lacks a separate register for reset; as a workaround,
> add a function that can be hooked to arm_pm_restart.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
