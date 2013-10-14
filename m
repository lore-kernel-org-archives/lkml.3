Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3JNNfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:35:32 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57152 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3JNNfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:35:31 -0400
Date: Mon, 14 Oct 2013 09:35:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Matias Bjorling <m@bjorling.me>
Cc: kmo@daterainc.com, paulmck@linux.vnet.ibm.com, tytso@mit.edu,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] percpu_refcount: Export symbols
Message-ID: <20131014133527.GE4722@htj.dyndns.org>
References: <1381740932-14419-1-git-send-email-m@bjorling.me>
 <1381740932-14419-2-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381740932-14419-2-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Andrew)

On Mon, Oct 14, 2013 at 10:55:32AM +0200, Matias Bjorling wrote:
> Export the interface to be used within modules.
> 
> Signed-off-by: Matias Bjorling <m@bjorling.me>

 Acked-by: Tejun Heo <tj@kernel.org>

Andrew, I don't have any percpu changes queued or scheduled for the
next merge window and I think it'd be easier if you can pick up this
one.  The original patch is at

 http://article.gmane.org/gmane.linux.kernel/1578435/raw

Thanks a lot!

-- 
tejun
