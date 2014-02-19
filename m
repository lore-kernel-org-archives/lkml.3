Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaBSKE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:04:28 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46789 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750921AbaBSKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:04:24 -0500
Date: Wed, 19 Feb 2014 10:04:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Wang YanQing <udknight@gmail.com>, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: update kmemleak.txt
Message-ID: <20140219100415.GB30457@arm.com>
References: <20140216164205.GA5941@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140216164205.GA5941@udknight>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 04:42:05PM +0000, Wang YanQing wrote:
> Update Documentatin/kmemleak.txt to
> reflect the following changes:
> 
> Commit b69ec42b1b194cc88f04b3fbcda8d3f93182d6c3
> ("Kconfig: clean up the long arch list for the DEBUG_KMEMLEAK config option")
> make we can't check supported architectures by read Kconfig.debug.
> 
> Commit 85d3a316c714197f94e75c1e5b2d37607d66e5de
> ("kmemleak: use rbtree instead of prio tree")
> convert kmemleak to use rbtree instead of prio tree.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Since it looks like akpm is picking this patch:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.
