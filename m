Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaDQTOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:14:23 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40210 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaDQTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:14:19 -0400
Date: Thu, 17 Apr 2014 15:14:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: Use more current logging style
Message-ID: <20140417191416.GS15326@htj.dyndns.org>
References: <1397748555-6647-1-git-send-email-nasa4836@gmail.com>
 <20140417153800.GO15326@htj.dyndns.org>
 <1397757955.3104.11.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397757955.3104.11.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:05:55AM -0700, Joe Perches wrote:
> Use pr_fmt and remove embedded prefixes.
> Realign modified multi-line statements to open parenthesis.
> Convert embedded function name to "%s: ", __func__
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Rolled into the series.  Will be applied after Jianyu's patch.

Thanks.

-- 
tejun
