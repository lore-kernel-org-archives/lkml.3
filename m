Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaLEVcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:32:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaLEVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:32:03 -0500
Date: Fri, 5 Dec 2014 13:32:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: jun.zhang@intel.com
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Changcheng Liu <changcheng.liu@intel.com>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched/fair: tiny clearup of -1
Message-ID: <20141205213202.GC3012@kroah.com>
References: <1417759365-28787-1-git-send-email-jun.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417759365-28787-1-git-send-email-jun.zhang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 02:02:45PM +0800, jun.zhang@intel.com wrote:
> From: zhang jun <jun.zhang@intel.com>
> 
> find_idlest_cpu don't return -1, so clearup it.
> 
> Signed-off-by: zhang jun <jun.zhang@intel.com>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Changcheng Liu <changcheng.liu@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Why me?  I don't care about this file...
