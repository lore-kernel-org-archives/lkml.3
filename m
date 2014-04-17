Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbaDQNO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaDQNOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:14:53 -0400
Date: Thu, 17 Apr 2014 14:16:37 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] ahci: Ensure "MSI Revert to Single Message" mode is
 not enforced
Message-ID: <20140417121636.GA2270@dhcp-26-207.brq.redhat.com>
References: <cover.1396426390.git.agordeev@redhat.com>
 <fe4097ff2b486092108663532c015a40984bc5f9.1396426390.git.agordeev@redhat.com>
 <20140416200132.GG22569@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416200132.GG22569@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 04:01:32PM -0400, Tejun Heo wrote:
> Can you please just open code this in ahci_init_interrupt()?  Also, do
> I need to backport this through -stable?  Has this been tested
> somehow?  What are the impacts of missing this?

Hi Tejun,

Sent out an updated version.
Yes, I think it needs to go to -stable.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
