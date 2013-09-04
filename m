Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013Ab3IDO6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:58:01 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44680 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934731Ab3IDO56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:57:58 -0400
Date: Wed, 4 Sep 2013 10:57:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904145743.GC25788@mtj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <20130903135541.GB10522@htj.dyndns.org>
 <20130903140954.GC10522@htj.dyndns.org>
 <20130904123238.GC8726@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904123238.GC8726@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 04, 2013 at 02:32:39PM +0200, Alexander Gordeev wrote:
> Hmm.. that is actually a great idea. What I am not sure about whether is
> a dummy port still can send (spurious?) interrupts? The hardware interrupt
> handler would have to be reworked then. Seems as a yet another topic to me ;)

Only unimplemented ports are assigned to be dummies and it's highly
unlikely that they'll generate spurious interrupts.  That said, I
think it'd be a good idea to be ready for that if that doesn't add too
much complexity / overhead.

Thanks.

-- 
tejun
