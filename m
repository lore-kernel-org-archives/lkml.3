Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289Ab3FTKS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:18:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab3FTKS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:18:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v2] irqchip: add support for MOXA ART SoCs
Date: Thu, 20 Jun 2013 12:17:47 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        thomas.petazzoni@free-electrons.com
References: <20130618154104.7f8115c7@skate> <1371718732-12680-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1371718732-12680-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201217.47903.arnd@arndb.de>
X-Provags-ID: V02:K0:zpijw9wQjACoPiHvqXQuiDMEmeWBFXbaQ5PZELk8jJq
 aKETYIZUp/+GxuTxuFhwyW5Bck9NDGJvaE6UZl8Jm2Kc6JTzki
 wNErz6Jz8uvQg3AZoQJSF/J0smTRJzKokevAPZuD9etCuEMYoI
 86XHXIJxozHKWE/Ao8PfFfzI1s8QAI2IjKpyJcHiu0v9RT26F5
 S/PEcUbdqzFarIOOQ495bBmZvsZCF5eiPcezUgnTSx4B+h+crO
 f7ibcl5sOb+VxlFRMF638eSFt9t0M4V+YfnQKjQrASEuMhI+5M
 FNCftGAjHV8t0s5DkTGF57MkNPuEgCZ2Mw2jlq1hE1vmXYY3Ja
 23HJVGTFDa8LC+2PIrUg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Jonas Jensen wrote:
> This patch adds an irqchip driver for the main interrupt controller found
> on MOXA ART SoCs.
> 
> v2:
> * use irq_chip_generic
> * remove macro duplicates
> 
> Applies to next-20130619
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
