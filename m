Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaIVP1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:27:21 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48787 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:27:20 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 22 Sep 2014 17:17:54 +0200
From: Johan Hovold <johan@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/9] rtc: at91sam9: add DT support
Message-ID: <20140922151754.GH5237@localhost>
References: <1411377058-26155-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411377058-26155-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411377058-26155-5-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please don't drop people from CC. ]

On Mon, Sep 22, 2014 at 11:10:53AM +0200, Boris BREZILLON wrote:
> Add of_match_table to the existing driver so that rtc nodes defined in at91
> DTs can be attached to this driver.

That should be rtt nodes.

Johan
