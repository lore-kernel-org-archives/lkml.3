Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaDGLRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:17:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:61990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaDGLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:17:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
Date: Mon, 07 Apr 2014 13:16:56 +0200
Message-ID: <4164782.o9VMXFGud6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396862008.3671.39.camel@pasglop>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <20140407083550.GF17163@e106497-lin.cambridge.arm.com> <1396862008.3671.39.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:u6MTHE0RHlrlaGGLSE4d17cMyB3hvqN20DUlpp0u0Ph
 8HOuuFLezjd4QgysI5MiYXtGULienqeXZnAyHlt12DphjqlWVd
 314hFKYlMkYhvTdmqASOlsS6x5JIFUXmA9LE9s0PlOPbKqGXRZ
 eioC98bco2cVfhe3KEdjCF62mXyZzzsgsOFplkocGZM+iPMC4P
 n2oEtmGnNGkN6JznTmwq7TgsibdINL4XRzTOtkZCfsYyuA7BhC
 zipMG2KsLa9+PhOXXHN1chCJOML4vSaPmX+6souZUj8xWcfE+G
 XjJqvWzt3GqB/EF7iEQjSjsrG1R1zJ+fr6lbCagcM3irveW/PM
 RpRgd3jjX/NBMEVLZNzk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2014 19:13:28 Benjamin Herrenschmidt wrote:
> On Mon, 2014-04-07 at 09:35 +0100, Liviu Dudau wrote:
> > Thanks for the summary, is really useful as I was recently looking
> > into code in that
> > area. One thing I was trying to understand is why ppc needs _IO_BASE
> > at all rather
> > than using the generic PCI_IOBASE? 
> 
> Perhaps because our code predates it ?  I haven't looked much into
> the semantics of PCI_IOBASE yet...

Yes, I'm pretty sure that's all there is to it. PCI_IOBASE just
happened to be an identifier we picked for asm-generic, but the
use on PowerPC is much older than the generic file.

	Arnd
