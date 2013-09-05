Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3IEPXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab3IEPXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:23:43 -0400
Date: Thu, 5 Sep 2013 17:25:39 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 5/6] AHCI: Check MRSM bit when multiple MSIs enabled
Message-ID: <20130905152539.GC30984@dhcp-26-207.brq.redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
 <4bc31d6ccf3f84399b977fe8ed4fe77aadfa1c79.1378383792.git.agordeev@redhat.com>
 <20130905131149.GC26314@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905131149.GC26314@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:11:49AM -0400, Tejun Heo wrote:
> On Thu, Sep 05, 2013 at 02:54:17PM +0200, Alexander Gordeev wrote:
> The patch should probably be re-sequenced to the head of the series
> and cc stable@vger.kernel.org.  Not checking MRSM is scary.

Will resend v3.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
