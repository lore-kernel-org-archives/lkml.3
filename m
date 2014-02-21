Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaBUSy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:54:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaBUSyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:54:25 -0500
Date: Fri, 21 Feb 2014 19:56:21 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] kvm: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140221185620.GA18725@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com>
 <5304B09D.7010900@redhat.com>
 <20140221170414.GM17353@dhcp-26-207.brq.redhat.com>
 <20140221170504.GN17353@dhcp-26-207.brq.redhat.com>
 <530788C1.6030109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530788C1.6030109@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 06:11:29PM +0100, Paolo Bonzini wrote:
> It's okay, but it's not clear to me whether I should include this
> patch or someone else will. :)

Please, include it.

Thanks!

> Paolo

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
