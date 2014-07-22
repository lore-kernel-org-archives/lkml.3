Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaGVPa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:30:28 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40403 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaGVPa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:30:27 -0400
Date: Tue, 22 Jul 2014 11:30:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: get the probable node ID from the first CPU
 of the mask
Message-ID: <20140722153023.GF13851@htj.dyndns.org>
References: <1406005442-12070-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406005442-12070-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:04:02PM +0800, Lai Jiangshan wrote:
> +		node = cpu_to_node(cpumask_first(pool->attrs->cpumask));

Minor but maybe cpumask_any() is a better fit here?

Thanks.

-- 
tejun
