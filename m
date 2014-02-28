Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaB1Poo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:44:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43797 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaB1Pon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:44:43 -0500
Message-ID: <5310AEA8.1070804@ti.com>
Date: Fri, 28 Feb 2014 10:43:36 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <galak@kernel.crashing.org>,
        <rob@landley.net>, <robherring2@gmail.com>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <rob.herring@calxeda.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, <nsekhar@ti.com>
Subject: Re: [PATCH v6 0/2]  Introduce AEMIF driver for Davinci/Keystone archs
References: <1393262772-24442-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1393262772-24442-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Monday 24 February 2014 12:26 PM, Ivan Khoronzhuk wrote:
> These patches introduce Async External Memory Interface (EMIF16/AEMIF)
> controller driver for Davinci/Keystone archs.
> 
> For more informations see documentation:
> Davinci DM646x - http://www.ti.com/lit/ug/sprueq7c/sprueq7c.pdf
> OMAP-L138 - http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
> Kestone - http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf
> 
[..]

> 
> v5..v6:
> - memory: ti-aemif: introduce AEMIF driver
> - memory: ti-aemif: add bindings for AEMIF driver
> 	changed opaque names for cs node properties
> 
Can you please pick these two patches ? 

Regards,
Santosh
