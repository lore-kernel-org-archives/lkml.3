Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaAXPn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:43:56 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:50734 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753281AbaAXPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:43:55 -0500
Date: Fri, 24 Jan 2014 15:43:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: =?utf-8?B?77+977+977+977+977+977+9?= <js07.lee@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Q] L1_CACHE_BYTES on flush_pfn_alias function.
Message-ID: <20140124154321.GI19052@arm.com>
References: <00d501cf136a$24ec49c0$6ec4dd40$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00d501cf136a$24ec49c0$6ec4dd40$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 09:54:42AM +0000, ������ wrote:
> Follow the mailing-list
> http://comments.gmane.org/gmane.linux.ports.arm.omap/31686
> 
> >>Setting the L1 cache line size larger than it actually is should be safe.
> 
> the written code expected as L1_CACHE_BYTES should be real cache line size
> has bug.
> It looks like that flush_pfn_alias function should be fixed.

Did you actually notice any problem with flushing some more bytes? It's
a clean+invalidate rather than invalidate, I don't see any problem.

-- 
Catalin
