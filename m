Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3G3M6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:58:49 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:45734 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3G3M6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:58:48 -0400
Date: Tue, 30 Jul 2013 08:58:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Xue jiufei <xuejiufei@huawei.com>
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: call_usermodehelper() returns -513 when ocfs2 umounting
 filesystems
Message-ID: <20130730125834.GA12016@htj.dyndns.org>
References: <51F76BA0.4000007@huawei.com>
 <51F77E7D.20608@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F77E7D.20608@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 04:51:09PM +0800, Xue jiufei wrote:
> The kernel version is 3.0.58.

That's way too old for upstream to do any meaningful debugging without
more specific information.  Kernel threads usually don't deal with
signals but there are a handful weird places in kernel which make use
of actual signals to affect the control flow.  ISTR modifying some so
that it's not too crazy but I could be misremembering....

Thanks.

-- 
tejun
