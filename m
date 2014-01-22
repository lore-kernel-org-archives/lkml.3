Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaAVJn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:43:59 -0500
Received: from smtp.citrix.com ([66.165.176.89]:41119 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbaAVJnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:43:55 -0500
X-IronPort-AV: E=Sophos;i="4.95,698,1384300800"; 
   d="scan'208";a="95227543"
Message-ID: <1390383831.32519.26.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v4] arm: remove !CPU_V6 and
 !GENERIC_ATOMIC64 build dependencies for XEN
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <will.deacon@arm.com>, <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <catalin.marinas@arm.com>, <jaccon.bastiaansen@gmail.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Wed, 22 Jan 2014 09:43:51 +0000
In-Reply-To: <1390311864-19119-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1390311864-19119-1-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 13:44 +0000, Stefano Stabellini wrote:
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

Acked-by: Ian Campbell <ian.campbell@citrix.com>


