Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaLYUME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 15:12:04 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:48354 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLYUMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 15:12:00 -0500
Date: Thu, 25 Dec 2014 15:11:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?IklzaGltYXRzdSwgWWFzdWFraS/nn7Pmnb4g6Z2W56ugIg==?= 
	<isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] workqueue: update numa affinity info at node hotplug
Message-ID: <20141225201156.GA22951@htj.dyndns.org>
References: <54905F87.2030302@jp.fujitsu.com>
 <549061BD.3040802@jp.fujitsu.com>
 <5490DE23.9000602@cn.fujitsu.com>
 <5490F70E.4010703@jp.fujitsu.com>
 <54910CFD.4070203@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54910CFD.4070203@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 01:56:29PM +0900, Kamezawa Hiroyuki wrote:
> Let me correct my words. Main purpose of this patch 1/2 is handling a case "node disappers" after boot.
> And try to handle physicall node hotplug caes.
> 
> Changes of cpu<->node relationship at CPU_ONLINE is handled in patch 2/2.

Can you please make numa code itself maintain the cpu to nodemask
maps?  Let's make workqueue a simple consumer of that and we don't
have proper notification mechanism for node up/down events?

Thanks.

-- 
tejun
