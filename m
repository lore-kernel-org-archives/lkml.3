Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbaCDEEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:04:54 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22222 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755977AbaCDEEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:04:53 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19/CPttpxFohZvpL2zSStTKnXiSMwE2gAo=
X-DKIM: OpenDKIM Filter v2.0.1 titan BB7D8539201
Date: Mon, 3 Mar 2014 23:04:43 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/5] phy: mvebu-sata: prepare new Dove DT Kconfig
 variable
Message-ID: <20140304040443.GI1872@titan.lakedaemon.net>
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393662801-17950-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393662801-17950-5-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 09:33:21AM +0100, Sebastian Hesselbarth wrote:
> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> DT-only MACH_DOVE Kconfig.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Kishon,
> 
> Mark Brown requested to take the corresponding ASoC patch through
> his tree. Therefore, I have split the former patch into individual subsystem
> patches. This patch also received an update, to not break bisectability
> we add DT-enabled MACH_DOVE and maintain ARCH_DOVE, which is non-DT only
> after conversion. ARCH_DOVE will be removed, when legacy mach-dove will
> be removed.
> 
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/phy/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Kishon,

fwiw:

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
