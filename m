Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab3ICNzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:55:46 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:46880 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3ICNzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:55:45 -0400
Date: Tue, 3 Sep 2013 09:55:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130903135541.GB10522@htj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378111919.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 02, 2013 at 10:59:07AM +0200, Alexander Gordeev wrote:
> This series is aimed to conserve on othewise wasted interrupt
> resources for 10 of 16 unused MSI vectors for AHCI devices on
> Intel chipsets.

Hmmm.... I've been looking at the code and and a curiosity.  Why does
multiple MSI support implicitly enabled threaded IRQ handling?  Why
are those two linked?  Also, do you have any numbers to show that this
actually is better?  Handling the processing off to a thread isn't a
light operation.

Thanks.

-- 
tejun
