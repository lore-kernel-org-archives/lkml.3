Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaDGJif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:38:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:33339 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbaDGJid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:38:33 -0400
Message-ID: <1396862008.3671.39.camel@pasglop>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 07 Apr 2014 19:13:28 +1000
In-Reply-To: <20140407083550.GF17163@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
	 <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
	 <20140405001953.GE15806@google.com> <1396777793.3671.15.camel@pasglop>
	 <20140407083550.GF17163@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 09:35 +0100, Liviu Dudau wrote:
> Thanks for the summary, is really useful as I was recently looking
> into code in that
> area. One thing I was trying to understand is why ppc needs _IO_BASE
> at all rather
> than using the generic PCI_IOBASE? 

Perhaps because our code predates it ? :-) I haven't looked much into
the semantics of PCI_IOBASE yet...

Cheers,
Ben.


