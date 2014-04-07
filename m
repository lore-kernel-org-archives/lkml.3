Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaDGJbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:31:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:44084 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbaDGJbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:31:34 -0400
Message-ID: <1396862058.3671.40.camel@pasglop>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for
 pci_host_bridge.
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
Date: Mon, 07 Apr 2014 19:14:18 +1000
In-Reply-To: <20140407084623.GG17163@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
	 <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
	 <20140405000007.GD15806@google.com>
	 <20140407084623.GG17163@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 09:46 +0100, Liviu Dudau wrote:
> 
> *My* strategy is to get rid of pci_domain_nr(). I don't see why we need
> to have arch specific way of providing the number, specially after looking
> at the existing implementations that return a value from a variable that
> is never touched or incremented. My guess is that pci_domain_nr() was
> created to work around the fact that there was no domain_nr maintainance in
> the generic code.

Well, there was no generic host bridge structure. There is one now, it should
go there.

Cheers,
Ben.
 

