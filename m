Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab3LIQpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:45:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51701 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844Ab3LIQpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:45:09 -0500
Message-ID: <52A5F355.9020704@ti.com>
Date: Mon, 9 Dec 2013 11:44:05 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <dwmw2@infradead.org>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 0/9] Reuse davinci-nand driver for Keystone arch
References: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Thursday 05 December 2013 12:25 PM, Ivan Khoronzhuk wrote:
> This series contains fixes and updates of Davinci nand driver in
> order to reuse it for Keystone platform.
> 
> v2..v3:
> - mtd: nand: davinci: don't set timings if AEMIF is used
> 	dropped, it would be replaced by alone patch
> 	ARM: davinci: aemif: get rid of davinci-nand driver dependency on aemif
> 
> v1..v2
> The series is combination of two following series:
> - Davinci nand driver fixes and updates:
> https://lkml.org/lkml/2013/11/20/271
> - Reuse davinci-nand driver for Keystone arch
> https://lkml.org/lkml/2013/11/20/315
> 
> - mtd: nand: davinci: extend description of bindings
> 	clarified changeset description
> 
> - mtd: nand: davinci: reuse driver for Keystone arch
> 	removed "ti,keystone-nand" compatible from driver
> 
> Ivan Khoronzhuk (9):
>   mtd: nand: davinci: fix driver registration
>   mtd: nand: davinci: return ENOMEM if memory allocation is failed
>   mtd: nand: davinci: check required ti,davinci-chipselect property
>   mtd: nand: davinci: simplify error handling
>   mtd: nand: davinci: move bindings under mtd
>   mtd: nand: davinci: extend description of bindings
>   mtd: nand: davinci: adjust DT properties to MTD generic
>   mtd: nand: davinci: reuse driver for Keystone arch
>   mtd: nand: davinci: don't request AEMIF address range
> 
Can you please pick up the $subject series if you are happy
with it ?
It lets us re-use Davinci nand driver on Keystone SOCs.

Regards,
Santosh

