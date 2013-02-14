Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab3BNO0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:26:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50697 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933991Ab3BNO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:26:40 -0500
Date: Thu, 14 Feb 2013 14:26:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: fix invocation of restore_altstack
Message-ID: <20130214142635.GT4503@ZenIV.linux.org.uk>
References: <20130214133552.GB25537@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214133552.GB25537@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 01:35:52PM +0000, Mark Rutland wrote:
> Hello,
> 
> I noticed the following issue while attempting to build an arm64 kernel from
> next-20130214, and it still seems to be present in signal/for-next and
> signal/arch-arm64.
> 
> It looks to be a trivial typo.

Thanks; folded and pushed.
