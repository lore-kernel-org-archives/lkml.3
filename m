Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3IEPV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab3IEPV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:21:56 -0400
Date: Thu, 5 Sep 2013 17:23:53 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 4/6] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130905152352.GB30984@dhcp-26-207.brq.redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
 <cb77da9322a63c609dc5aa49aa57c9706bf37a24.1378383792.git.agordeev@redhat.com>
 <20130905131050.GB26314@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905131050.GB26314@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:10:50AM -0400, Tejun Heo wrote:
> One more question tho.  How much does saving some interrupt vectors
> matter?  Are int vectors contrained resource on some configurations?

Honestly, I am not aware of any configuration struggling with interrupt
vectors. However, conserving on x86 interrupt vector space is always a
good idea IMO. Also, PPC pSeries has a concept of MSI quota, so..

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
