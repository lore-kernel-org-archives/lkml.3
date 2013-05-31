Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3EaKhC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:37:02 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62476 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab3EaKhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:37:00 -0400
Date: Fri, 31 May 2013 11:36:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 1/6] [HACK!] arm64/xen: create links to arch/arm
 include files and Xen code
Message-ID: <20130531103617.GA18045@localhost.cambridge.arm.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
 <1369930713-6063-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369930713-6063-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 05:18:28PM +0100, Stefano Stabellini wrote:
> Most of Xen support for ARM is common between ARMv7 and ARMv8.
> Create links to the code under arch/arm (bleah).
> 
> Other, probably better alternatives:
> 
> - move the code to a different location, maybe the header files to
> include/xen/arm and the code to drivers/xen/arm (still pretty ugly)?
> 
> - create a copy of the code to arch/arm64 (even worse);

KVM handles this in the Makefile by referencing back to arch/arm or even
the generic kvm directory. I think that's the 'cleanest' ;)

-- 
Catalin
