Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaBUQuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:50:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141AbaBUQuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:50:44 -0500
Date: Fri, 21 Feb 2014 17:52:35 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] xen-pciback: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140221165235.GF17353@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-10-git-send-email-agordeev@redhat.com>
 <5304CC49.7020000@oracle.com>
 <5304D063.90000@oracle.com>
 <20140219160501.GA32067@dhcp-26-207.brq.redhat.com>
 <5304DABD.9000605@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5304DABD.9000605@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:24:29AM -0500, Boris Ostrovsky wrote:

Hi Boris et al,

Based on recently accepted to the mainline pci_enable_msix_exact() function,
I am sending an updated version of the patch.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
