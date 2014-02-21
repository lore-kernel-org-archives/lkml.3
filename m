Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaBUVPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:15:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26513 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaBUVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:15:15 -0500
Date: Fri, 21 Feb 2014 16:15:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] xen-pciback: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140221211508.GJ26880@phenom.dumpdata.com>
References: <1392804931-30671-10-git-send-email-agordeev@redhat.com>
 <5304CC49.7020000@oracle.com>
 <5304D063.90000@oracle.com>
 <20140219160501.GA32067@dhcp-26-207.brq.redhat.com>
 <5304DABD.9000605@oracle.com>
 <20140221165235.GF17353@dhcp-26-207.brq.redhat.com>
 <20140221165340.GG17353@dhcp-26-207.brq.redhat.com>
 <53079BFE.3010702@oracle.com>
 <20140221185858.GB18725@dhcp-26-207.brq.redhat.com>
 <5307A44E.7060006@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5307A44E.7060006@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 02:09:02PM -0500, Boris Ostrovsky wrote:
> On 02/21/2014 01:58 PM, Alexander Gordeev wrote:
> >On Fri, Feb 21, 2014 at 01:33:34PM -0500, Boris Ostrovsky wrote:
> >>Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> >Thank you, Boris!
> >Whom should I ask this patch for inclusion?
> >
> 
> This should go into the Xen tree. Konrad is usually the one putting
> together pull requests for Linus.
> 
> I don't think this needs to go in right away so presumably this will
> be queued for the next merge window (unless Konrad has other things
> for next RCs and decides to tack this onto other patches).

I was thinking for next one. Will have a branch ready on Monday.
> 
> 
> -boris
