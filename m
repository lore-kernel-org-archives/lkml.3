Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaDRRTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:19:30 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:38620 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaDRRTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:19:24 -0400
Date: Fri, 18 Apr 2014 13:19:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 7/8] idr: don't need to shink the free list when
 idr_remove()
Message-ID: <20140418171920.GF23576@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-8-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397825404-12039-8-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:49:54PM +0800, Lai Jiangshan wrote:
> After idr subsystem is changed to RCU-awared, the free layer will not go to
> the free list. The free list will not be filled up when idr_remove().
> So we don't need to shink it too.
> 
> "#ifndef TEST" can't work for user space test now, just remove it.

Maybe put this in a separate patch?

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
