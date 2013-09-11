Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3IKK74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:59:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40757 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754156Ab3IKK7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:59:55 -0400
Date: Wed, 11 Sep 2013 11:59:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <pinskia@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Andrew Pinski <apinski@cavium.com>
Subject: Re: [PATCH 2/5] ARM64: Move some signal code to a seperate file to
 be reused by ILP32.
Message-ID: <20130911105929.GC26777@darko.cambridge.arm.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
 <1378762380-13152-2-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378762380-13152-2-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:32:56PM +0100, Andrew Pinski wrote:
> Since the ILP32 ABI uses similar signal code as the LP64 ABI, it makes sense to reuse rather
> than copy the same code.

At a first look, I don't really like this part. I'll comment more on the
last patch.

-- 
Catalin
