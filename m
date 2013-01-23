Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3AWBIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:08:55 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:64033 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855Ab3AWBIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:08:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/I4Q1/7uT0Plyba1mZS1DFarPhKLukgk4=
Date: Tue, 22 Jan 2013 20:08:47 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Cong Ding <dinggnu@gmail.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] clk: mvebu/clk-cpu.c: fix memory leakage
Message-ID: <20130123010847.GA1758@titan.lakedaemon.net>
References: <1358183892-28928-1-git-send-email-dinggnu@gmail.com>
 <50F563EC.3030804@free-electrons.com>
 <20130115152307.GA25615@gmail.com>
 <20130115153716.GF13433@titan.lakedaemon.net>
 <50F584F5.6030007@free-electrons.com>
 <20130115182629.GB7211@gmail.com>
 <50F5A1A9.2030803@free-electrons.com>
 <20130115184423.GC7211@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115184423.GC7211@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 07:44:26PM +0100, Cong Ding wrote:
> the variable cpuclk and clk_name should be properly freed when error happens.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> ---
>  drivers/clk/mvebu/clk-cpu.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Applied to mvebu/fixes with MikeT's Ack.

thx,

Jason.
