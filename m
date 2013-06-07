Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3FGPaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:30:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3FGPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:30:19 -0400
Date: Fri, 7 Jun 2013 17:30:14 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/50] ARM: at91: add PMC main clock
Message-ID: <20130607173014.7186ddc0@skate>
In-Reply-To: <1370615115-16979-3-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
	<1370615115-16979-3-git-send-email-b.brezillon@overkiz.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Boris BREZILLON,

On Fri,  7 Jun 2013 16:24:10 +0200, Boris BREZILLON wrote:

> + * This mainram is free software; you can redistribute it and/or modify

Looks like you did some funky 'sed' over your source files. In every
clk driver, instead of "program" you have "<name of clock>ram" :-)

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
