Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbbAMMls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:41:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:44794 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbAMMlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:41:47 -0500
Date: Tue, 13 Jan 2015 13:41:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC PATCH] irqchip: add dumb demultiplexer implementation
In-Reply-To: <20150113115830.43ef505d@bbrezillon>
Message-ID: <alpine.DEB.2.11.1501131340290.5526@nanos>
References: <alpine.DEB.2.11.1412162125000.17382@nanos> <1420725159-20720-1-git-send-email-boris.brezillon@free-electrons.com> <alpine.DEB.2.11.1501131117120.17382@nanos> <20150113115830.43ef505d@bbrezillon>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Boris Brezillon wrote:
> Hmm, my question was not really clear: I was talking about irq flags [1]
> (those that are set with irq_modify_status in the generic irq chip [2]).

Ah, ok. Taking the same approach should be ok.

Thanks,

	tglx
