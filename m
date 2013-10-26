Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3JZR1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 13:27:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58020 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849Ab3JZR1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 13:27:37 -0400
Date: Sat, 26 Oct 2013 18:27:35 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] extcon: arizona: Fix reset of HPDET after race
	with removal
Message-ID: <20131026172735.GK20219@opensource.wolfsonmicro.com>
References: <1382796618-19921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1382796618-19921-2-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20131026162907.GC7698@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026162907.GC7698@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 09:29:07AM -0700, Lee Jones wrote:
> What happens if we don't update the bits and we still do magic in the
> new error path? Does that adversely affect any later 'goto done's?

I think best leave this patch for now I should probably rethink
it slightly, as you say I am not sure all the paths through are
correct there.

I will post a new version shortly.

Thanks,
Charles
