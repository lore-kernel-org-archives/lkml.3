Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3FKIqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:46:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:60684 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3FKIqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:46:35 -0400
Date: Tue, 11 Jun 2013 10:46:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] irqchip: add support for Marvell Orion SoCs
In-Reply-To: <1370536034-23956-2-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <alpine.LFD.2.02.1306111045520.22970@ionos>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com> <1370536034-23956-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Sebastian Hesselbarth wrote:

> This patch adds an irqchip driver for the main interrupt controller found
> on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation).
> Corresponding device tree documentation is also added.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
