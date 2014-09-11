Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbaIKQqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:46:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48486 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752786AbaIKQqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:46:54 -0400
Date: Thu, 11 Sep 2014 18:46:51 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] irqchip: atmel-aic5: Add sama5d4 support
Message-ID: <20140911184651.7d81c238@free-electrons.com>
In-Reply-To: <20140911162727.GA3131@piout.net>
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1410450852-1834-2-git-send-email-alexandre.belloni@free-electrons.com>
	<20140911182411.0366ad98@free-electrons.com>
	<20140911162727.GA3131@piout.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre Belloni,

On Thu, 11 Sep 2014 18:27:27 +0200, Alexandre Belloni wrote:
> > Sorry for the nitpick, but this seems to lack an updated to the DT
> > binding documentation, to add the new compatible string.
> > 
> 
> The Atmel SoC compatibles are not actually documented anywhere, yet...

Sorry, I pointed the wrong piece of code. I should have pointed out:

IRQCHIP_DECLARE(sama5d4_aic5, "atmel,sama5d4-aic", sama5d4_aic5_of_init);

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
