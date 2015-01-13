Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbbAMJZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:25:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60313 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752065AbbAMJZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:25:36 -0500
Date: Tue, 13 Jan 2015 10:25:32 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 6/6] ARM: at91: move at91rm9200_idle() to clk/at91/pmc.c
Message-ID: <20150113102532.4f75926f@bbrezillon>
In-Reply-To: <1421097825-396-7-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1421097825-396-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 22:23:45 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> Move at91rm9200_idle() along with at91sam9_idle() in clk/at91/pmc.c.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> 
> Mike, Boris,
> I guess that one can go through the at91 tree unless you have any objections.

I'm fine with that too.


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
