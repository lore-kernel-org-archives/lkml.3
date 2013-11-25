Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3KYNrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:47:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3KYNre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:47:34 -0500
Date: Mon, 25 Nov 2013 14:49:15 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 09/29] PCI/MSI: Factor out pci_get_msi_cap()
 interface
Message-ID: <20131125134914.GA6924@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
 <85500e7239fcb104df091bbfa873eef8ae654772.1382103786.git.agordeev@redhat.com>
 <20131120161808.GI28946@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120161808.GI28946@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:18:08AM -0500, Tejun Heo wrote:
> > +If this function returns a negative number, it indicates the device is
> > +not capable of sending MSIs.
> 
> Wouldn't "errno" better describe the error return rather than
> "negative number"?

Term "negative number" is used throughout the whole document.
Could be updated in a separate patch if it worth it.

> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
