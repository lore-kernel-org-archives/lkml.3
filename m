Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386Ab3FSKWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:22:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17129 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914Ab3FSKWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:22:04 -0400
X-Spam-Score: -100.8
Message-ID: <51C1861A.6030901@asianux.com>
Date: Wed, 19 Jun 2013 18:21:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of spin_lock
 + local_irq_save, especially when CONFIG_LOCKDEP not defined
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 05:59 PM, Thomas Gleixner wrote:
> I'm well aware how that works. And there is no difference whether you
> do:
> 
> 	local_irq_save(flags);
> 	spin_lock(&lock);
> or
> 	spin_lock_irqsave(&lock, flags);

if CONFIG_LOCKDEP is not defined, they are not semantically the same.


Thanks.
-- 
Chen Gang

Asianux Corporation
