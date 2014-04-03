Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaDCL7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:59:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41927 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaDCL7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:59:03 -0400
X-IronPort-AV: E=Sophos;i="4.97,786,1389744000"; 
   d="scan'208";a="116407428"
Message-ID: <533D4D04.2010101@citrix.com>
Date: Thu, 3 Apr 2014 12:59:00 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <JBeulich@suse.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] Fixes to Linux v3.13 - bugs.xenproject.org ones. (v1).
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> Hey,
> 
> Two of these:
>  [PATCH 2/4] xen/manage: Poweroff forcefully if user-space is not yet
>  [PATCH 4/4] xen/xenbus: Avoid synchronous wait on XenBus stalling
> 
> fix the bugs.xenproject.org outstanding bugs.
> 
> The other ones are that were discovered on xen-devel and discussed.
> They should go in v3.13 and as the merge window is next week I am
> hoping they can be squeezed in then.
> 
> 
>  drivers/xen/manage.c            | 64 ++++++++++++++++++++++++++++++++++-------
>  drivers/xen/pci.c               | 47 ++++++++++++++++++++++++++++++
>  drivers/xen/xenbus/xenbus_xs.c  | 24 ++++++++++++++--
>  include/xen/interface/physdev.h | 11 +++++++
>  
> Konrad Rzeszutek Wilk (4):
>       xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas.
>       xen/manage: Poweroff forcefully if user-space is not yet up.
>       xen/manage: Guard against user-space initiated poweroff and XenBus.
>       xen/xenbus: Avoid synchronous wait on XenBus stalling shutdown/restart.

Konrad, can you repost a final series please?  I'm not 100% which
patches should be applied.

David
