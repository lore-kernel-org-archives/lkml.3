Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3BVI2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:28:47 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:8386 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3BVI2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:28:44 -0500
X-IronPort-AV: E=Sophos;i="4.84,714,1355097600"; 
   d="scan'208";a="1770297"
Message-ID: <1361521714.26546.91.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH XEN] xen: event channel arrays are xen_ulong_t and not
 unsigned long
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Keir Fraser <keir.xen@gmail.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, "Keir (Xen.org)" <keir@xen.org>,
        "Tim (Xen.org)" <tim@xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 22 Feb 2013 08:28:34 +0000
In-Reply-To: <CD4C1B4B.4C72B%keir.xen@gmail.com>
References: <CD4C1B4B.4C72B%keir.xen@gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 18:43 +0000, Keir Fraser wrote:
> On 21/02/2013 17:16, "Ian Campbell" <Ian.Campbell@citrix.com> wrote:
> 
> > On Tue, 2013-02-19 at 14:49 +0000, Ian Campbell wrote:
> >> On ARM we want these to be the same size on 32- and 64-bit.
> >> 
> >> This is an ABI change on ARM. X86 does not change.
> >> 
> >> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> >> Cc: Jan Beulich <JBeulich@suse.com>
> >> Cc: Keir (Xen.org) <keir@xen.org>
> > 
> > Are you guys (un)happy with this change from the Xen & x86 side?
> 
> Fine by me.

I'm going to take that as an Acked-by then, assuming that's ok with you.
I suppose Fine-by: Keir would do too ;-)

Ian.


