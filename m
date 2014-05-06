Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbaEFDqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:46:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:35562 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606AbaEFDqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:46:11 -0400
Message-ID: <1399347878.20388.96.camel@pasglop>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Date: Tue, 06 May 2014 13:44:38 +1000
In-Reply-To: <CAErSpo6gYT34-sOvNgEdV+3wxv=Fdqtx7c1d-4577mFydLtZMg@mail.gmail.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	 <20923376.buVzFR52Qe@wuerfel>
	 <CAErSpo5-FXmVs8BWRYKz9Ln1g1Ls7_uo3oiPd32fUegf3d8hXQ@mail.gmail.com>
	 <5575019.Hr92MUuDnc@wuerfel>
	 <CAErSpo6gYT34-sOvNgEdV+3wxv=Fdqtx7c1d-4577mFydLtZMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 16:28 -0600, Bjorn Helgaas wrote:
> I still wonder whether arm, powerpc, and tile (and I just noticed
> microblaze also has a similar dma_direct_map_page()) could all be
> handled by attaching devices to a generic trivial IOMMU driver
> parameterized with the appropriate constant offset.

On powerpc, the offset is not constant, it can be per-device

Cheers,
Ben.


