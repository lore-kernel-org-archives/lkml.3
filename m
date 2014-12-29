Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaL2MbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:31:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52702 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751435AbaL2MbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:31:08 -0500
Date: Mon, 29 Dec 2014 13:30:59 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mtd: nand: atmel: Update DT documentation after
 splitting NFC and NAND
Message-ID: <20141229133059.1c3c6a6e@bbrezillon>
In-Reply-To: <549D2A9D.50407@atmel.com>
References: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com>
	<1417732214-3292-3-git-send-email-boris.brezillon@free-electrons.com>
	<549D2A9D.50407@atmel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2014 17:30:05 +0800
Josh Wu <josh.wu@atmel.com> wrote:

> Hi, Boris
> 
> Thanks for the patch.
> 
> You need to rebase on the top of current mtd-l2 git tree. As I had some 
> change on the binding document.

Sure, I'll do it, but I'd like to have feedback from Nicolas, Brian and
at least one DT maintainer first.

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
