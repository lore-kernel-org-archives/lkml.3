Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3HUFbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:31:47 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:48305 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3HUFbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:31:46 -0400
Date: Wed, 21 Aug 2013 09:31:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        riel@redhat.com, hughd@google.com, xemul@parallels.com,
        rientjes@google.com, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: shmem: check the return value of mpol_to_str()
Message-ID: <20130821053142.GQ18673@moon>
References: <5212E8DF.5020209@asianux.com>
 <20130820053036.GB18673@moon>
 <52130194.4030903@asianux.com>
 <20130820064730.GD18673@moon>
 <52131F48.1030002@asianux.com>
 <52132011.60501@asianux.com>
 <52132432.3050308@asianux.com>
 <20130820082516.GE18673@moon>
 <52142422.9050209@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52142422.9050209@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:21:22AM +0800, Chen Gang wrote:
> mpol_to_str() may fail, and not fill the buffer (e.g. -EINVAL), so need
> check about it, or buffer may not be zero based, and next seq_printf()
> will cause issue.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>

Looks good to me, thanks!

Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
