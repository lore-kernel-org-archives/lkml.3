Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaDPI0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:26:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:10229 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaDPI0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:26:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,870,1389744000"; 
   d="scan'208";a="120421206"
Message-ID: <1397636798.24638.117.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] drivers: net: xen-netfront: remove unused
 arrays
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Vincenzo Maffione <v.maffione@gmail.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 16 Apr 2014 09:26:38 +0100
In-Reply-To: <534D7244.5000002@citrix.com>
References: <1397583579-32162-1-git-send-email-v.maffione@gmail.com>
	 <534D7244.5000002@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 18:54 +0100, David Vrabel wrote:
> On 15/04/14 18:39, Vincenzo Maffione wrote:
> > This patch removes some unused arrays from the netfront
> > private data structure.
> > Also removes an unused address variable.
> > 
> > Signed-off-by: Vincenzo Maffione <v.maffione@gmail.com>
> 
> Huh. I wonder what they were for.

Looks like they were leftovers from the old flipping mode of operation.
Which was removed with:
        commit 5dcddfae63bd26da0f11a8e40f0ae555b5ac624e
        Author: Jeremy Fitzhardinge <jeremy@goop.org>
        Date:   Tue Aug 7 14:56:42 2007 -0700
        
            xen-netfront: remove dead code
        
Which missed these bits.
Ian.

> Acked-by: David Vrabel <david.vrabel@citrix.com>
> 
> For net related patches please say whether they're for the net (current
> RCs) or net-next branch.  e.g.,
> 
> [PATCH net-next] xen-netfront: removed unused arrays.
> 
> Thanks.
> 
> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


