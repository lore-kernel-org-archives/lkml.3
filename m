Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3JIN27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:28:59 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51924 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754220Ab3JIN24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:28:56 -0400
Date: Wed, 9 Oct 2013 14:28:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tim Bird <tim.bird@sonymobile.com>
Cc: "cl@linux.com" <cl@linux.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "bjorn.andersson@sonymobile.com" <bjorn.andersson@sonymobile.com>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roman Bobniev <Roman.Bobniev@sonymobile.com>
Subject: Re: [PATCH] slub: proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
Message-ID: <20131009132816.GA32201@arm.com>
References: <1381273137-14680-1-git-send-email-tim.bird@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381273137-14680-1-git-send-email-tim.bird@sonymobile.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:58:57PM +0100, Tim Bird wrote:
> From: Roman Bobniev <Roman.Bobniev@sonymobile.com>
> 
> Move all kmemleak calls into hook functions, and make it so
> that all hooks (both inside and outside of #ifdef CONFIG_SLUB_DEBUG)
> call the appropriate kmemleak routines.  This allows for kmemleak
> to be configured independently of slub debug features.
> 
> It also fixes a bug where kmemleak was only partially enabled in some
> configurations.
> 
> Signed-off-by: Roman Bobniev <Roman.Bobniev@sonymobile.com>
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>

Looks ok to me.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
