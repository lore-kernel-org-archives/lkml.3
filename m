Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3HMIan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:30:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58364 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751122Ab3HMIak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:30:40 -0400
Date: Tue, 13 Aug 2013 10:30:30 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Bjorn Helgaas <bhelgaas@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
Message-ID: <20130813103030.1e4156a1@skate>
In-Reply-To: <20130813080956.GE9316@ulmo>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130813080956.GE9316@ulmo>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thierry Reding,

On Tue, 13 Aug 2013 10:09:56 +0200, Thierry Reding wrote:

> > +- reset-gpios: optional gpio to PERST#
> > +- reset-delay-ms: delay in ms to wait after reset de-assertion
> 
> I remember some recent discussion about this, and we now have this reset
> framework, so perhaps it makes more sense to use the reset binding for
> this? Cc'ing Stephen (as part of the device tree bindings maintainers
> team) who was involved in that recent reset bindings discussion.

I also thought about this, but the reset framework seems to be designed
for "reset controller" IPs, i.e special IPs that are controlling reset
signals. Looking at Documentation/devicetree/bindings/reset/reset.txt,
I'm not sure to see how this would apply to GPIO-controlled reset
signals.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
