Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3HTIZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:25:22 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49416 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3HTIZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:25:20 -0400
Date: Tue, 20 Aug 2013 12:25:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        riel@redhat.com, hughd@google.com, xemul@parallels.com,
        rientjes@google.com, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: mempolicy: the failure processing about
 mpol_to_str()
Message-ID: <20130820082516.GE18673@moon>
References: <5212E8DF.5020209@asianux.com>
 <20130820053036.GB18673@moon>
 <52130194.4030903@asianux.com>
 <20130820064730.GD18673@moon>
 <52131F48.1030002@asianux.com>
 <52132011.60501@asianux.com>
 <52132432.3050308@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52132432.3050308@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:09:22PM +0800, Chen Gang wrote:
> So, for simplify thinking and implementation, use your patch below is OK
> to me (but I suggest to print error information in the none return value
> function).

Chen, I'm not going to dive into this area now, too busy with other stuff
sorry, so if you consider my preliminary draft patch useful -- pick it up,
modify it, test it and send to lkml then (just CC me).
