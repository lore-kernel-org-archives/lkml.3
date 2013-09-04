Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063Ab3IDPCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:02:45 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39951 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934791Ab3IDPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:02:41 -0400
Date: Wed, 4 Sep 2013 11:02:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904150233.GD25788@mtj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <20130903135541.GB10522@htj.dyndns.org>
 <20130903145719.GB14221@dhcp-26-207.brq.redhat.com>
 <20130903162411.GA25040@mtj.dyndns.org>
 <20130904080623.GB8726@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904080623.GB8726@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 04, 2013 at 10:06:23AM +0200, Alexander Gordeev wrote:
> > Please separate out threaded IRQ support from multiple MSI.
> 
> This series does not really bring any structural change to the AHCI code -
> just tweaks the MSI initialization.
> 
> As threaded IRQ support vs multiple MSI is a separate issue what about
> addressing it in a separate effort? I would have to think on how to do it
> eigher :)

Oh, I'm not saying that these all should be done together but it looks
like you're interested in pushing things further in this respect and I
wanna have an idea about the overall direction / future before acking
further changes.  IOW, I'm happy that you're working on it but also
wanna make sure you're gonna see things through and know where things
are headed.

Thanks!

-- 
tejun
