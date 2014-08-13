Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaHMJWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:22:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53630 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbaHMJWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:22:11 -0400
Date: Wed, 13 Aug 2014 10:22:09 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: patches@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mfd: arizona: Mark additional registers as volatile
Message-ID: <20140813092209.GE15833@opensource.wolfsonmicro.com>
References: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1407851483-19207-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407851483-19207-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 02:51:23PM +0100, Charles Keepax wrote:
> Mark some additional registers as volatile. The write sequencer control
> registers should not be cached, as we don't ever want their value
> synchronised as this might cause a write sequence to be accidentally
> initiated.
> 
> Additionally, the DAC_COMP registers require special preconditions to
> write so there values wouldn't be updated accurately during a register
> sync.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---

Apologies please ignore this patch, I forgot I was carrying a
patch from Mark that it depends on that doesn't appear to be in
your MFD tree. I will resend Mark's patch first.

Thanks,
Charles
