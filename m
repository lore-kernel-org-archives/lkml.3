Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3EBITT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:19:19 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:41814 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3EBITQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:19:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4146054"
Message-ID: <1367482754.21869.25.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/3] xen: move do_stolen_accounting to
 drivers/xen/time.c
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 2 May 2013 09:19:14 +0100
In-Reply-To: <1367436460-10183-2-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
	 <1367436460-10183-2-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 20:27 +0100, Stefano Stabellini wrote:
> Move do_stolen_accounting, xen_vcpu_stolen and related functions and
> static variables to common code (drivers/xen/time.c).
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> +	/* work out how much time the VCPU has not been runn*ing*  */

I wonder what this emphasis on runn*ing* means?

Ian.

