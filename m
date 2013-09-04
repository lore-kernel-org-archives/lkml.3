Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab3IDSp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:45:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759920Ab3IDSpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:45:24 -0400
Date: Wed, 4 Sep 2013 20:47:16 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904184715.GA24341@dhcp-26-207.brq.redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
 <20130903141824.GD10522@htj.dyndns.org>
 <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
 <20130903182731.GA27092@mtj.dyndns.org>
 <20130904072256.GA8726@dhcp-26-207.brq.redhat.com>
 <20130904145559.GB25788@mtj.dyndns.org>
 <20130904161442.GE8726@dhcp-26-207.brq.redhat.com>
 <20130904180607.GD26609@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904180607.GD26609@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 02:06:07PM -0400, Tejun Heo wrote:
> I don't think it's necessary / a good idea to try to support
> everything.  Just following the spec would be fine.  If that doesn't
> work for too many devices, maybe just do one fallback?

Calling pci_enable_msi_block_part() in a loop may seem not that terrible
if you think of the original interface - pci_enable_msi_block(). If we
were to enable multiple MSIs using that one we still had to use it pretty
much the same way ;)

Anyway. I will send a version which reads MMC out.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
