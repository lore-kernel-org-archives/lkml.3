Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3FQIfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:35:36 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44381 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3FQIfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:35:33 -0400
Date: Mon, 17 Jun 2013 09:35:25 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: linux-next: manual merge of the arm64-hugepages tree with the
 arm64 tree
Message-ID: <20130617083524.GA28225@linaro.org>
References: <20130617173627.8bd67da7e93639cf85afcedb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617173627.8bd67da7e93639cf85afcedb@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 05:36:27PM +1000, Stephen Rothwell wrote:
> Hi Steve,

Hi Stephen,

> 
> Today's linux-next merge of the arm64-hugepages tree got a conflict in
> arch/arm64/Kconfig between commit aa42aa1389a5 ("arm64/xen: introduce
> CONFIG_XEN and hypercall.S on ARM64") from the arm64 tree and commit
> d03bb1455f3a ("ARM64: mm: Raise MAX_ORDER for 64KB pages and THP") from
> the arm64-hugepages tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks this fixup looks good to me.

Cheers,
-- 
Steve
