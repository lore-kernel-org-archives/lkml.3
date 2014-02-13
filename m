Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaBMRhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:37:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaBMRhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:37:14 -0500
Date: Thu, 13 Feb 2014 18:39:10 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/22] bfa: Do not call pci_enable_msix() once it failed
Message-ID: <20140213173910.GA26610@dhcp-26-207.brq.redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
 <a2c28d9475021b99aa35bba9e84f4237d6b32cde.1391512266.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2c28d9475021b99aa35bba9e84f4237d6b32cde.1391512266.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 12:16:48PM +0100, Alexander Gordeev wrote:
> Function pci_enable_msix() should not be called again in
> case it threw a negative errno.

Anil, Vijaya,

Any feedback on bfa patches?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
