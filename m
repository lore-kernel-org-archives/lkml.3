Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3CQPcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:32:33 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57190 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab3CQPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <201303151125.53999.arnd@arndb.de>
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com>
	<CACmBeS05cyT8N9nZeqbJUPMSGeZYLWjL0Tu1GSZ-ms+Hjc0UoQ@mail.gmail.com>
	<5140C6B2.7040702@gmail.com>
	<201303151125.53999.arnd@arndb.de>
Date: Sun, 17 Mar 2013 16:32:30 +0100
Message-ID: <CACmBeS3aXs9vhc5ZYPbz5bjsYsSa6EzM12H4uPv706x0zU_5iw@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Mack <zonque@gmail.com>,
        linux@arm.linux.org.uk, linux-mmc@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the feedback.

Some of the changes are sure to be a challenge for me, but I want to
move this forward, and having a list helps.

3.2.40 is as far as it'll go right now, nothing prints to UART
starting with 3.3.8 (last tested, it's somewhere around there).

I have been advised to enable early_printk (by landley on freenode IRC #edev).

Best regards,
Jonas
