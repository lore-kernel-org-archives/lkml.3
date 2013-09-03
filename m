Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab3ICOTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:19:15 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:35853 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3ICOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:19:14 -0400
Date: Tue, 3 Sep 2013 10:19:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/4] PCI/MSI: Introduce pci_enable_msi_block_part()
 interface
Message-ID: <20130903141909.GE10522@htj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <35d9a944d441e23fbbcb5dc3fb710cada0fa272c.1378111919.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35d9a944d441e23fbbcb5dc3fb710cada0fa272c.1378111919.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 10:59:33AM +0200, Alexander Gordeev wrote:
> +	if (__roundup_pow_of_two(nvec_mme) != nvec_mme)

Why the __ prefixed version?

-- 
tejun
