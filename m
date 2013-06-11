Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3FKNN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:13:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:34207 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3FKNN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:13:26 -0400
Date: Tue, 11 Jun 2013 15:13:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Marvell Orion SoC irqchip and clocksource
In-Reply-To: <51B71AF6.1090108@gmail.com>
Message-ID: <alpine.LFD.2.02.1306111512480.22970@ionos>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130611123521.GA3996@localhost> <51B71AF6.1090108@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Sebastian Hesselbarth wrote:
> On 06/11/13 14:35, Ezequiel Garcia wrote:
> With Thomas Gleixner's Review now only somebody has to take the irqchip
> patch then all three drivers are queued for next release.

I can take it through tip if nobody else wants it :)
