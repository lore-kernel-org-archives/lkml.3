Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762247Ab3IDIEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762128Ab3IDIE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:04:28 -0400
Date: Wed, 4 Sep 2013 10:06:23 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904080623.GB8726@dhcp-26-207.brq.redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
 <20130903135541.GB10522@htj.dyndns.org>
 <20130903145719.GB14221@dhcp-26-207.brq.redhat.com>
 <20130903162411.GA25040@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903162411.GA25040@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 12:24:11PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 03, 2013 at 04:57:19PM +0200, Alexander Gordeev wrote:
> > Multiple MSI support enables threaded IRQ handling, because at the time of
> > posting I did not want to intrude into the existing single-MSI codebase while
> > multiple MSI/multipe CPU approach gained good numbers (below).
> 
> Please separate out threaded IRQ support from multiple MSI.

This series does not really bring any structural change to the AHCI code -
just tweaks the MSI initialization.

As threaded IRQ support vs multiple MSI is a separate issue what about
addressing it in a separate effort? I would have to think on how to do it
eigher :)

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
