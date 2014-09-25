Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaIYIKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:10:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39058 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbaIYIKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:10:17 -0400
Date: Thu, 25 Sep 2014 09:10:14 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, subhransu.s.prusty@intel.com,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 03/27] extcon: arizona: use
	pm_runtime_last_busy_and_autosuspend helper
Message-ID: <20140925081014.GI29992@opensource.wolfsonmicro.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com> <1411575342-31048-4-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411575342-31048-4-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:44:53PM +0530, Vinod Koul wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
