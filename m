Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab3FTMv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:51:26 -0400
Received: from 8bytes.org ([85.214.48.195]:34877 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970Ab3FTMvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:51:23 -0400
Date: Thu, 20 Jun 2013 14:51:20 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
Message-ID: <20130620125120.GP2575@8bytes.org>
References: <CAErSpo7onNaU5mquJ_a7kwGPgzs3Q_7U89__HT9DbJFkUX4fsQ@mail.gmail.com>
 <20130529083652.GA25971@dhcp-26-207.brq.redhat.com>
 <CAErSpo4EkXX-UoFLyni+ZpXaTmCRq5sJCqZ4FCt7fywpDyVWqw@mail.gmail.com>
 <CAErSpo6bjBEK=Ta=pVzwCBMfrqfe3jB-sEfv1Kz9mt9iakdeaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6bjBEK=Ta=pVzwCBMfrqfe3jB-sEfv1Kz9mt9iakdeaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 14:51:22 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c2faca20861818510844
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 02:46:59PM -0600, Bjorn Helgaas wrote:
> I pushed these with updates to
> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/alexander-msi
> 
> Anybody want to ack the iommu/irq_remapping.c patch?  If so, I can
> merge that branch into -next for v3.11.

Sorry for being unresponsive, things habe been pretty busy here :-(
The changes look good, you have my

Acked-by: Joerg Roedel <joro@8bytes.org>


