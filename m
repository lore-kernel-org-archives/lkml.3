Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbaGXRNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:13:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:43380 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391AbaGXRNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:13:23 -0400
Date: Thu, 24 Jul 2014 19:13:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Make PCIe PME interrupts wake up from "freeze"
 sleep state
Message-ID: <20140724171320.GL3935@laptop>
References: <12684812.i3F8JrYCl0@vostro.rjw.lan>
 <20140724134241.GZ6758@twins.programming.kicks-ass.net>
 <3655886.Ih7L6voqVK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3655886.Ih7L6voqVK@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 05:36:28PM +0200, Rafael J. Wysocki wrote:

> OK, so can you please test the updated patch below?

Rejoyce, it works! ;-)
