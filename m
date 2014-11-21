Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbaKUKnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:43:51 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:58962 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbaKUKnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:43:50 -0500
Message-ID: <1416566627.6958.16.camel@x220>
Subject: arm: pxa: CPU_PXA27x?
From: Paul Bolle <pebolle@tiscali.nl>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kbuild@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Nov 2014 11:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2014 10:43:47.0531 (UTC) FILETIME=[079739B0:01D00578]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

Your commit 03ec7fe70c5c ("arm: pxa: add pxa27x device-tree support") is
included in today's linux-next (ie, next-20141121). It adds a select
statement for CPU_PXA27x. But there's no Kconfig symbol CPU_PXA27x.

Why is that select needed? For what it's worth: __cpu_is_pxa27x()
compiles to something interesting if CONFIG_PXA27x is defined.

In https://lkml.org/lkml/2014/9/30/578 I proposed a patch that emits a
warning in cases like this. Like _all_ Kconfig related patches I've seen
flying by lately it appears to be dropped in /dev/null. What's going on?


Paul Bolle

