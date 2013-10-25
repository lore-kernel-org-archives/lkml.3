Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3JYJ7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3JYJ7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:59:14 -0400
Date: Fri, 25 Oct 2013 12:01:04 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Mark Lord <kernel@start.ca>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*()
 family helpers
Message-ID: <20131025100103.GA317@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
 <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
 <20131024105158.GB13159@mtj.dyndns.org>
 <AE90C24D6B3A694183C094C60CF0A2F6026B73AA@saturn3.aculab.com>
 <20131024114133.GA26610@dhcp-26-207.brq.redhat.com>
 <5269D5D1.60103@start.ca>
 <AE90C24D6B3A694183C094C60CF0A2F6026B73B0@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B73B0@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 10:10:02AM +0100, David Laight wrote:
> What this doesn't resolve is a driver requesting a lot of interrupts
> early on and leaving none for later drivers.

If this problem really exists anywhere besides pSeries?

I can imagine x86 hitting lack of vectors in interrupt table when
number of CPUs exceeds hundreds, but do we have this problem now?

> Really the system needs to allocate the minimum number to all
> drivers before giving out any extra ones - I've NFI how this
> would be arranged!

Do not know. The pSeries quota approach seems more reasonable to me.

> 	David

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
