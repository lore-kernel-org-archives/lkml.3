Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab3KVSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:25:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3KVSZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:25:25 -0500
Date: Fri, 22 Nov 2013 19:27:12 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 06/29] PCI/MSI: Get rid of useless count of
 msi_desc leftovers
Message-ID: <20131122182711.GD8401@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
 <79a2aeb6a06563c5f09463d53d2e0146e44c92be.1382103786.git.agordeev@redhat.com>
 <20131120160716.GF28946@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120160716.GF28946@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:07:16AM -0500, Tejun Heo wrote:
> Hmmm... so, before this, the function would have returned the partial
> number of irqs that arch set up successfully.  Is it okay to lose that
> information?  If so, can you please elaborate a bit more on why it's
> okay in the description?

Well, this is embarrassing. A quick check into x86 shows the partially
initialized MSI-Xs are possible - something I should have noticed.

Self-Nack.

> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
