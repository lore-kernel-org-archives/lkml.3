Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3HUOdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:33:00 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57936 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3HUOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:32:58 -0400
Date: Wed, 21 Aug 2013 10:32:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com, guohanjun@huawei.com
Subject: Re: [PATCH v2 0/3] workqueue: Comment/Doc correction with no
 functional change
Message-ID: <20130821143254.GM19286@mtj.dyndns.org>
References: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 08:50:38AM +0800, Libin wrote:
> This patch set doesn't make any functional differences.
> 
> Libin (3):
>   workqueue: Comment correction in file header
>   workqueue: Fix manage_workers() RETURNS description
>   workqueue: Correct/Drop references to gcwq in Documentation

Applied 1-3 to wq/for-3.12 with minor updates.

Thanks.

-- 
tejun
