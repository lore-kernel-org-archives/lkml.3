Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaIKJlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:41:47 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39968 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaIKJlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:41:45 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 11 Sep 2014 11:39:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 0/8] rtc: at91sam9: add DT support
Message-ID: <20140911093942.GA12295@localhost>
References: <1410425767-17874-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410425767-17874-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:55:59AM +0200, Boris BREZILLON wrote:

> Johan, let me know if this version addresses part of your concerns.

Looks good to me. I just have a few minor comments on two of the patches.

> I'm open to any suggestion/rework to address other previously discussed
> issues, as long as it does not end up in a dead-end (like the discussion
> you had last year):
>  - the fact that the RTT block could be used for something that is not
>    an RTC
>  - the fact that referencing the GPBR node and defining a GPBR register
>    number to store RTC time info could be considered as an HW config and
>    not an HW description and thus should not be described in the DT

No doubt.

>  - other things I don't remember :-)

Thanks,
Johan
