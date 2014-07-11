Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaGKPRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:17:55 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:35537 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaGKPRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:17:52 -0400
Date: Fri, 11 Jul 2014 11:17:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: reuse the calculated pwq in
 try_to_grab_pending()
Message-ID: <20140711151748.GA29137@htj.dyndns.org>
References: <1405008673-12805-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405008673-12805-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:11:13AM +0800, Lai Jiangshan wrote:
> Subsitute the get_work_pwq(work) to pwq since it is calculated.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to libata/for-3.17 w/ updated patch description.

Thanks.

-- 
tejun
