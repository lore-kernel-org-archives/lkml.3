Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3HWTdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:33:31 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41277 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226Ab3HWTda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:33:30 -0400
Date: Fri, 23 Aug 2013 14:33:25 -0500
From: Ben Myers <bpm@sgi.com>
To: zwu.kernel@gmail.com
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] xfs: introduce object readahead to log recovery
Message-ID: <20130823193325.GV5262@sgi.com>
References: <1376464563-27821-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376464563-27821-1-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 03:16:03PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   It can take a long time to run log recovery operation because it is
> single threaded and is bound by read latency. We can find that it took
> most of the time to wait for the read IO to occur, so if one object
> readahead is introduced to log recovery, it will obviously reduce the
> log recovery time.
> 
> Log recovery time stat:
> 
>           w/o this patch        w/ this patch
> 
> real:        0m15.023s             0m7.802s
> user:        0m0.001s              0m0.001s
> sys:         0m0.246s              0m0.107s
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.
