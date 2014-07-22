Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaGVPes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:34:48 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34451 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaGVPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:34:47 -0400
Date: Tue, 22 Jul 2014 11:34:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: remove the suspicuous out_unlock label in
 get_unbound_pool()
Message-ID: <20140722153443.GH13851@htj.dyndns.org>
References: <1406005489-12140-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406005489-12140-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:04:49PM +0800, Lai Jiangshan wrote:
> After the locking was moved up to the caller of the get_unbound_pool(),
> out_unlock label doesn't need to do any unlock operation and the name
> became bad, so we just remove this label, and the only usage-site
> "goto out_unlock" is subsituted to "return pool".
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17 w/ minor edits.

Thanks.

-- 
tejun
