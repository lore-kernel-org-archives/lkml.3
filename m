Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3BDVkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:40:04 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:34407 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BDVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:40:02 -0500
Date: Mon, 4 Feb 2013 13:39:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] workqueue: add worker's global worker ID
Message-ID: <20130204213957.GF27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-13-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-13-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 02:41:35AM +0800, Lai Jiangshan wrote:
> Add worker->gwid which is allocated from worker_idr.  This
> will be used to record the last running worker in work->data.

worker->id is almost completely cosmetic at this point.  Maybe we want
to rename it to something, say, worker->id_in_pool and use worker->id
for the global id?

Thanks.

-- 
tejun
