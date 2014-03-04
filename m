Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaCDEDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:03:30 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64596 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbaCDED3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:03:29 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+vXMG973+kHqm4rlOYjS5W03nBYoq8zEI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1C48C5391DF
Date: Mon, 3 Mar 2014 23:03:18 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] thermal: dove: prepare new Dove DT Kconfig
 variable
Message-ID: <20140304040318.GG1872@titan.lakedaemon.net>
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393662801-17950-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393662801-17950-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 09:33:19AM +0100, Sebastian Hesselbarth wrote:
> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> DT-only MACH_DOVE Kconfig.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Rui, Eduardo,
> 
> Mark Brown requested to take the corresponding ASoC patch through
> his tree. Therefore, I have split the former patch into individual subsystem
> patches.              
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/thermal/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
