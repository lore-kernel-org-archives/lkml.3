Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3CTVuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:50:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CTVuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:50:09 -0400
Date: Wed, 20 Mar 2013 14:50:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dgilbert@interlog.com>
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
Message-Id: <20130320145006.f1431c1528325ff93a298790@linux-foundation.org>
In-Reply-To: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com>
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013 18:37:12 +0100 Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> On some revisions of AT91 SoCs, the RTC IMR register is not working.
> Instead of elaborating a workaround for that specific SoC or IP version,
> we simply use a software variable to store the Interrupt Mask Register and
> modify it for each enabling/disabling of an interrupt. The overhead of this
> is negligible anyway.

This description doesn't really allow me or others to work out whether
the fix should be included in 3.9 or backported into earlier kernels.

So please, when fixing a bug do include a full description of the
user-visible effects of that bug.  And your opinion regarding the
-mainline and -stable decision is always useful.
