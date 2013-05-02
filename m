Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499Ab3EBSXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:23:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:55782 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760261Ab3EBSXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:23:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,597,1363132800"; 
   d="scan'208";a="22986080"
Date: Thu, 2 May 2013 19:23:11 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v10 0/2] (arm-soc for v3.10) arm: introduce
 psci_smp_ops
In-Reply-To: <20130502181851.GB14496@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1305021920070.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304301707290.5398@kaball.uk.xensource.com> <alpine.DEB.2.02.1305021811560.5398@kaball.uk.xensource.com> <20130502171516.GA3040@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1305021816490.5398@kaball.uk.xensource.com>
 <20130502181851.GB14496@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Russell King - ARM Linux wrote:
> On Thu, May 02, 2013 at 06:20:32PM +0100, Stefano Stabellini wrote:
> > On Thu, 2 May 2013, Will Deacon wrote:
> > > Hi Stefano,
> > > 
> > > On Thu, May 02, 2013 at 06:12:12PM +0100, Stefano Stabellini wrote:
> > > > ping
> > > 
> > > Is this a ping to have this pulled into Russell's tree?
> > 
> > I thought that we agreed that the patches should go via the arm-soc
> > tree, after Russell acks them.
> > 
> > The ping is for Russell to ack them and Arnd to merge them.
> 
> Sorry but I tend not to be around on Tuesdays and Wednesdays, which leads
> to a hell of an email problem on Thursdays.  I haven't looked at them in
> any great detail (I just paged through them so far and on to the next
> email.)

No problems, if there is one person that can understand being flooded by
emails, that's me.


> I don't really have sufficient time to properly deal with all the email
> traffic that is now on this list - even from just flicking through the
> messages.  It's far too much.

This patches have been discussed in great details, would you be content
with Will Deacon and Nicolas Pitre's Acks?
Nobody objected again them so far.
