Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaBQKUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:20:20 -0500
Received: from top.free-electrons.com ([176.31.233.9]:37954 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751074AbaBQKUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:20:16 -0500
Date: Mon, 17 Feb 2014 11:20:13 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: at91: Add at91sam9rl DT SoC support
Message-ID: <20140217112013.723a4e12@skate>
In-Reply-To: <1392426860-19589-2-git-send-email-alexandre.belloni@free-electrons.com>
References: <1392426860-19589-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1392426860-19589-2-git-send-email-alexandre.belloni@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Belloni,

On Sat, 15 Feb 2014 02:14:18 +0100, Alexandre Belloni wrote:

> +	model = "Atmel AT91SAM9RL family SoC";
> +	compatible = "atmel,at91sam9rl";

Since you have it in your board .dts file, I guess you should add the
atmel,at91sam9 compatible string here:

	compatible = "atmel,at91sam9rl", "atmel,at91sam9";

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
