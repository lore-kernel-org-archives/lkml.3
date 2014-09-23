Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaIWESW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:18:22 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:57139 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaIWESU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:18:20 -0400
Date: Tue, 23 Sep 2014 00:18:17 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923041817.GA11740@mtj.dyndns.org>
References: <20140923140633.35efbe7a@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923140633.35efbe7a@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:06:33PM +1000, NeilBrown wrote:
...
> Note that reads from a sysfs file are already safe due to the use for
> seqfile.  The first read will allocate a buffer (m->buf) which will
> be used for all subsequent reads.

Hmmm?  How is seqfile safe?  Where would the seq op write to?

Thanks.

-- 
tejun
