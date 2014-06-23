Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaFWSmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:42:52 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43818 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaFWSmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:42:51 -0400
Date: Mon, 23 Jun 2014 14:42:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Maxime Bizon <mbizon@freebox.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: fix dev_set_uevent_suppress imbalance.
Message-ID: <20140623184247.GC18451@mtj.dyndns.org>
References: <1403534135-29241-1-git-send-email-mbizon@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403534135-29241-1-git-send-email-mbizon@freebox.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 04:35:35PM +0200, Maxime Bizon wrote:
> Uevents are suppressed during attributes registration, but never
> restored, so kobject_uevent() does nothing.
> 
> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>

Applied to wq/for-3.16-fixes.

Thanks.

-- 
tejun
