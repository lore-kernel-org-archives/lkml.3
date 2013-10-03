Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3JCU2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:28:55 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:39704 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab3JCU2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:28:53 -0400
Date: Thu, 3 Oct 2013 22:24:56 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: kirkwood: retain MAC address for DT ethernet
Message-ID: <20131003202456.GH20056@lunn.ch>
References: <1380804294-13726-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1380826568-18587-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20131003190201.GA2504@localhost>
 <20131003190437.GY31178@titan.lakedaemon.net>
 <20131003194449.GB30298@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003194449.GB30298@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sebastian, does __clk_enabled work properly for the mvebu clock
> provider? I don't see a clk_ops.is_enabled for mvebu.. (don't know
> much about clk)

Hi Jason

It is implemented in drivers/clk/clk-gate.c, which is what mvebu is
using.

   Andrew
