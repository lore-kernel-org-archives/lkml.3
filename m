Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaAUSMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:12:21 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64817 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbaAUSMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:12:18 -0500
Date: Tue, 21 Jan 2014 18:07:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH v4] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build
 dependencies for XEN
Message-ID: <20140121180750.GO30706@mudshark.cambridge.arm.com>
References: <1390311864-19119-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390311864-19119-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 01:44:24PM +0000, Stefano Stabellini wrote:
> Remove !GENERIC_ATOMIC64 build dependency:
> - introduce xen_atomic64_xchg
> - use it to implement xchg_xen_ulong
> 
> Remove !CPU_V6 build dependency:
> - introduce __cmpxchg8 and __cmpxchg16, compiled even ifdef
>   CONFIG_CPU_V6
> - implement sync_cmpxchg using __cmpxchg8 and __cmpxchg16
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: arnd@arndb.de
> CC: linux@arm.linux.org.uk
> CC: will.deacon@arm.com
> CC: catalin.marinas@arm.com
> CC: linux-arm-kernel@lists.infradead.org
> CC: linux-kernel@vger.kernel.org
> CC: xen-devel@lists.xenproject.org

  Reviewed-by: Will Deacon <will.deacon@arm.com>

Cheers Stefano,

Will
