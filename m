Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3KNO6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:58:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53842 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab3KNO6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:58:44 -0500
Date: Thu, 14 Nov 2013 14:58:42 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] extcon: arizona: Add defines for microphone
	detection levels
Message-ID: <20131114145842.GI6549@opensource.wolfsonmicro.com>
References: <1384438297-27851-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20131114143606.GA4996@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114143606.GA4996@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:36:06PM +0000, Lee Jones wrote:
> On Thu, 14 Nov 2013, Charles Keepax wrote:
> 
> > Improve readability by creating a define for each microphone detection
> > level.
> > 
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/extcon/extcon-arizona.c       |   19 ++++++++++++++-----
> >  include/linux/mfd/arizona/registers.h |    9 +++++++++
> >  2 files changed, 23 insertions(+), 5 deletions(-)
> 
> You've missed off my Ack for the MFD parts.

Sorry yeah I should have added that.

Thanks,
Charles
