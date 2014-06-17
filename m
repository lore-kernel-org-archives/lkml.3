Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965488AbaFQQcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:32:48 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:50575 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965435AbaFQQcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:32:46 -0400
Date: Tue, 17 Jun 2014 12:32:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 8/9] ata: Add support for the Tegra124 SATA controller
Message-ID: <20140617163242.GK31819@htj.dyndns.org>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <1401881559-18469-9-git-send-email-mperttunen@nvidia.com>
 <1470404.13mIFv0Hnj@amdc1032>
 <53A0686F.4000303@wwwdotorg.org>
 <20140617161320.GG31819@htj.dyndns.org>
 <20140617161447.GH31819@htj.dyndns.org>
 <53A06B65.7030407@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A06B65.7030407@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:23:01AM -0600, Stephen Warren wrote:
> > Please also drop inline.  It isn't a difficult optimization to perform
> > for the compiler.
> 
> There are probably hundreds of drivers marking those functions inline.

We used to need them.  We no longer do.  We're in a very long
transition phase.

> If they aren't marked inline, it'll just stick out as unusual when
> people read them all, and then they'll send patches to fix it.

Don't worry.  They won't be applied.

Thanks.

-- 
tejun
