Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaIOIZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:25:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbaIOIZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:25:19 -0400
Date: Mon, 15 Sep 2014 09:34:20 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 1/3] PCI/MSI/PPC: Remove arch_msi_check_device()
Message-ID: <20140915083418.GC8793@agordeev.usersys.redhat.com>
References: <cover.1410078503.git.agordeev@redhat.com>
 <a7a806c4f531ba80386e9d0baf69571a827ea59c.1410078503.git.agordeev@redhat.com>
 <1410748970.24738.3.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410748970.24738.3.camel@concordia>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 12:42:50PM +1000, Michael Ellerman wrote:
> On Sun, 2014-09-07 at 20:57 +0200, Alexander Gordeev wrote:
> > Moving MSI checks from arch_msi_check_device() function to
> > arch_setup_msi_irqs() function makes code more compact and
> > allows removing unnecessary hook arch_msi_check_device()
> > from generic MSI code.
> > 
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: linux-pci@vger.kernel.org
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> 
> I already acked the previous version, but if you didn't want it that's fine :)

I do want it, but I thought you may not agree with the new changelog ;)

> cheers
> 
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
