Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3KKJXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:23:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab3KKJW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:22:57 -0500
Date: Mon, 11 Nov 2013 09:22:54 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] extcon: arizona: Eliminate dead error handling code
Message-ID: <20131111092254.GC6549@opensource.wolfsonmicro.com>
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1383916783-17921-4-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20131111090014.GB30901@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111090014.GB30901@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 09:00:14AM +0000, Lee Jones wrote:
> > As a small disclaimer I would personally prefer to not merge this patch.
> > I have added it based on previous code review of the other patches in
> > this chain.
> 
> I'd prefer the functionally redundant 'else if' over the comment.
> 
> I'm happy not to merge this patch.

I agree entirely the redundant 'else if' is much better.

Thanks,
Charles
