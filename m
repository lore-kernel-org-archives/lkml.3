Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaDGOjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:39:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34569 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGOjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:39:53 -0400
Date: Mon, 7 Apr 2014 15:38:50 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 5/6] pci: Export find_pci_host_bridge() function.
Message-ID: <20140407153850.3c9ef3e5@alan.etchedpixels.co.uk>
In-Reply-To: <20140407142045.GO17163@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
	<1394811272-1547-6-git-send-email-Liviu.Dudau@arm.com>
	<20140404233948.GC15806@google.com>
	<20140407142045.GO17163@e106497-lin.cambridge.arm.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If we *do* export it, I'd like it to have a more conventional name, e.g.,
> > something starting with "pci_".
> 
> Understood. pci_find_host_bridge() ?

pci_get_host_bridge() and take a reference IMHO ? If your primary bus is
not PCI then your PCI "host" bridge could be hot swappable so the API at
least ought to get that right.

Alan
