Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3BVI26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:28:58 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:8386 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3BVI2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:28:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,714,1355097600"; 
   d="scan'208";a="1770299"
Message-ID: <1361521720.26546.93.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH XEN] xen: event channel arrays are xen_ulong_t and not
 unsigned long
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir (Xen.org)" <keir@xen.org>, "Tim (Xen.org)" <tim@xen.org>
Date: Fri, 22 Feb 2013 08:28:40 +0000
In-Reply-To: <5127366502000078000C0380@nat28.tlf.novell.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
	 <1361285363-27133-1-git-send-email-ian.campbell@citrix.com>
	 <1361466961.26546.85.camel@zakaz.uk.xensource.com>
	 <5127366502000078000C0380@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 08:12 +0000, Jan Beulich wrote:
> >>> On 21.02.13 at 18:16, Ian Campbell <Ian.Campbell@citrix.com> wrote:
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
> I don't see any problem with it.

I'll take this as an Acked-by if that's ok with you.

Ian.

