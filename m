Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaEAQKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:10:15 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53777 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaEAQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:10:13 -0400
Date: Thu, 1 May 2014 09:10:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 2/2] Hexagon: Delete stale barrier.h
Message-ID: <20140501161005.GA6212@roeck-us.net>
References: <1397808515-8013-1-git-send-email-vgupta@synopsys.com>
 <1397808515-8013-3-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397808515-8013-3-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 01:38:35PM +0530, Vineet Gupta wrote:
> It is likely Hexagon build is broken too in 3.15.
> But I don't have a working compiler to be sure.
> 
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Hexagon build is still broken with 3.15-rc3 and with the latest upstream.
This patch fixes the (build) problem. Would be great if the arch maintainer
could apply this (or a similar) patch and send it to Linus.

Compile-tested-by: Guenter Roeck <linux@roeck-us.net>
