Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaENExT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 00:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaENExS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 00:53:18 -0400
Date: Wed, 14 May 2014 06:54:10 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] rapidio/tsi721: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-ID: <20140514045410.GA12932@dhcp-26-207.brq.redhat.com>
References: <1399993292-31692-1-git-send-email-agordeev@redhat.com>
 <20140513144634.c7bc3d20db633f32fea913b6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513144634.c7bc3d20db633f32fea913b6@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 02:46:34PM -0700, Andrew Morton wrote:
> On Tue, 13 May 2014 17:01:32 +0200 Alexander Gordeev <agordeev@redhat.com> wrote:
> 
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers
> > using these two interfaces need to be updated to use the
> > new pci_enable_msi_range()  or pci_enable_msi_exact()
> > and pci_enable_msix_range() or pci_enable_msix_exact()
> > interfaces.
> > 
> 
> What (if any) runtime effect does this patch have?

None.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
