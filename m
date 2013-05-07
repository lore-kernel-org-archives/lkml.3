Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab3EGNfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:35:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59659 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058Ab3EGNfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:35:02 -0400
X-IronPort-AV: E=Sophos;i="4.87,628,1363132800"; 
   d="scan'208";a="23728333"
Date: Tue, 7 May 2013 14:34:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>, "olof@lixom.net" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>
Subject: Re: [Xen-devel] [PATCH RFC v2 2/4] arm: introduce CONFIG_PARAVIRT
 and pv_time_ops
In-Reply-To: <1367931376.26321.117.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1305071433560.4147@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>  <1367851878-21629-2-git-send-email-stefano.stabellini@eu.citrix.com>  <1367918609.26321.43.camel@zakaz.uk.xensource.com>  <alpine.DEB.2.02.1305071301040.4147@kaball.uk.xensource.com>
 <1367931376.26321.117.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013, Ian Campbell wrote:
> On Tue, 2013-05-07 at 13:15 +0100, Stefano Stabellini wrote:
> > On Tue, 7 May 2013, Ian Campbell wrote:
> > > On Mon, 2013-05-06 at 15:51 +0100, Stefano Stabellini wrote:
> > > > Introduce CONFIG_PARAVIRT on ARM.
> > > 
> > > What about PARAVIRT_TIME_ACCOUNTING? I'm not sure what it is but it
> > > looks like a more lightweight version of pv stolen time?
> >  
> > PARAVIRT_TIME_ACCOUNTING selects PARAVIRT on x86 :-)
> 
> Ah, that's maybe what confused me.
> 
> TBH its not at all clear to me what distinction the core code is trying
> to make with those two options, but do we not also want/need
> PARAVIRT_TIME_ACCOUNTING? Having reread the help text it seems to be
> some sort of "more accurate" accounting?

It is not clear to me either.
I think that you are right, we probably want PARAVIRT_TIME_ACCOUNTING too.
