Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaCEJZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:25:34 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:38924 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbaCEJZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:25:28 -0500
Date: Wed, 5 Mar 2014 10:24:17 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Revert "irqchip: irq-dove: Add PMU interrupt controller."
Message-ID: <20140305092417.GB26485@lunn.ch>
References: <20140304030838.GA1872@titan.lakedaemon.net>
 <1393911160-7688-1-git-send-email-jason@lakedaemon.net>
 <20140305004139.GT21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305004139.GT21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From the spec, it looks like this is probably true of DFSDone as well.

The cpufreq driver makes use of DFSDone. I've never had it loop
endlessly. There is also no action needed to clear it in the DFS
hardware.

	Andrew
