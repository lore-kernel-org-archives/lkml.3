Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3ENKpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:45:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31142 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3ENKpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:45:51 -0400
X-Spam-Score: -100.8
Message-ID: <519215AC.4010109@asianux.com>
Date: Tue, 14 May 2013 18:45:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] kernel/irqdesc.c: not checking whether failure occurs
 for alloc_desc() in early_irq_init().
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

For early_irq_init(), it may be failure (can return an error code), and
for alloc_desc(), also may return 'NULL' when '-ENOMEM'.

But it seems the authors are sure that early_irq_init() are always
success, is it correct ? (or early_irq_init() will never be used ?)

I think, it is better to also check alloc_desc() return value in
early_irq_init().

Please help check when you have time.


Thanks.
-- 
Chen Gang

Asianux Corporation
