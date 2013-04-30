Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab3D3C04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759276Ab3D3C0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:26:55 -0400
Date: Mon, 29 Apr 2013 23:10:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: KVM_CAP_IOMMU only available with device assignment
Message-ID: <20130430021002.GA14088@amt.cnet>
References: <20130429165334.19404.54557.stgit@bling.home>
 <517EA6F2.706@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517EA6F2.706@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 09:59:30AM -0700, Randy Dunlap wrote:
> On 04/29/13 09:54, Alex Williamson wrote:
> > Fix build with CONFIG_PCI unset by linking KVM_CAP_IOMMU to
> > device assignment config option.  It has no purpose otherwise.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Thanks.

Applied, thanks.

