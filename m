Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3JGQdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:33:33 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51649 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756618Ab3JGQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:33:31 -0400
Date: Mon, 7 Oct 2013 17:32:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Will Deacon <Will.Deacon@arm.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        "linux@openrisc.net" <linux@openrisc.net>
Subject: Re: [PATCH v2 19/29] of: create default
 early_init_dt_add_memory_arch
Message-ID: <20131007163220.GJ32012@arm.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
 <1381163377-21044-20-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381163377-21044-20-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 05:29:27PM +0100, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Create a weak version of early_init_dt_add_memory_arch which uses
> memblock. This will unify all architectures except ones with custom
> memory bank structs.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Jonas Bonn <jonas@southpole.se>
> Acked-by: Grant Likely <grant.likely@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: microblaze-uclinux@itee.uq.edu.au
> Cc: linux@lists.openrisc.net
> Cc: devicetree@vger.kernel.org

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
