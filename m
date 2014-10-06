Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaJFSWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:22:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53320 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaJFSWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:22:17 -0400
Date: Mon, 6 Oct 2014 19:21:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        mark.rutland@arm.com, graeme.gregory@linaro.org, marc.zyngier@arm.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org, astone@redhat.com,
        grant.likely@linaro.org, hanjun.guo@linaro.org, Sudeep.Holla@arm.com,
        olof@lixom.net, jason@lakedaemon.net, "Duran, Leo" <leo.duran@amd.com>,
        Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH 1/4] ata: ahci_platform: Add ACPI support for AMD Seattle
 SATA controller
Message-ID: <20141006182153.GA31521@srcf.ucam.org>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
 <4872185.h11DQxW6kP@wuerfel>
 <20141006163147.GA22482@srcf.ucam.org>
 <2026795.jAP8HDLAZo@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026795.jAP8HDLAZo@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 08:19:37PM +0200, Arnd Bergmann wrote:

> Interesting. Does this also define a way to get access to registers
> that are normally in PCI config space, provided they are accessible at
> all?

Unfortunately not. I'd assume that PM registers are expected to be 
accessed via the _PS* methods instead. Does MSI make sense outside the 
context of PCI interrupts?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
