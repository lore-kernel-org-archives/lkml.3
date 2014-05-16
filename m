Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbaEPRYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:24:03 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63463 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaEPRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:23:59 -0400
Date: Fri, 16 May 2014 13:23:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 cgroup/for-3.16] cgroup: introduce CSS_NO_REF and skip
 refcnting on normal root csses
Message-ID: <20140516172356.GH5379@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
 <1399670015-23463-10-git-send-email-tj@kernel.org>
 <53751062.2050401@wwwdotorg.org>
 <53753823.2090402@wwwdotorg.org>
 <20140516143718.GA5379@htj.dyndns.org>
 <20140516154330.GB5379@htj.dyndns.org>
 <537643F9.1030303@wwwdotorg.org>
 <20140516170959.GG5379@htj.dyndns.org>
 <5376489C.9010902@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5376489C.9010902@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:19:24AM -0600, Stephen Warren wrote:
> On 05/16/2014 11:09 AM, Tejun Heo wrote:
> > Can you try this one instead?
> 
> Yes, this one works great, thanks.
> Tested-by: Stephen Warren <swarren@nvidia.com>

Thanks, I reverted the original one and applied the updated one w/
your Tested-by tag added.

-- 
tejun
