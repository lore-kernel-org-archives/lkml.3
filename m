Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774Ab3ECI0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:26:51 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:56323 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762733Ab3ECI0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:26:48 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4194280"
Message-ID: <1367569605.28742.28.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/3] xen: move do_stolen_accounting to
 drivers/xen/time.c
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Christopher Covington <cov@codeaurora.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 3 May 2013 09:26:45 +0100
In-Reply-To: <5182B532.10607@codeaurora.org>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
	 <1367436460-10183-2-git-send-email-stefano.stabellini@eu.citrix.com>
	 <5182B532.10607@codeaurora.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 19:49 +0100, Christopher Covington wrote:
> Hi Stefano,
> 
> On 05/01/2013 03:27 PM, Stefano Stabellini wrote:
> > Move do_stolen_accounting, xen_vcpu_stolen and related functions and
> > static variables to common code (drivers/xen/time.c).
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/xen/time.c   |  127 +-------------------------------------------
> 
> In going through some of the code, it looked like there might be a few little
> bits that you might be interested in pulling out of arch/ia64/xen/time.c as well.

ia64 in the hypervisor was deprecated and with the 4.3 release has been
removed.

AFAIK ia64/Xen support has been broken in the mainline kernel for year.

Ian

