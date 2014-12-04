Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaLDSAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:00:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38954 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbaLDSAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:00:01 -0500
Date: Thu, 4 Dec 2014 12:59:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH v5] Fixes for PCI backend for 3.19.
Message-ID: <20141204175950.GB3409@laptop.dumpdata.com>
References: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
 <548081E2.3080703@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548081E2.3080703@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:46:42PM +0000, David Vrabel wrote:
> On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote:
> > 
> > These patches fix some issues with PCI back and also add proper
> > bus/slot reset.
> 
> Applied 1-8 to devel/for-linus-3.19.  I did not apply #9.

Excellent. Thank you!
> 
> Thanks.
> 
> David
