Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbaBURCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:02:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbaBURCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:02:17 -0500
Date: Fri, 21 Feb 2014 18:04:15 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] kvm: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140221170414.GM17353@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com>
 <5304B09D.7010900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5304B09D.7010900@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo et al,

Based on recently accepted to the mainline pci_enable_msix_exact() function,
I am sending a updated version of the patch. Please, let me know if it does
not work for you and you need and incremental update from the previous version.

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
