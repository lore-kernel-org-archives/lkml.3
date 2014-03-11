Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaCKMzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:55:33 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42149 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaCKMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:55:32 -0400
Date: Tue, 11 Mar 2014 08:55:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, joe@perches.com,
        mingo@kernel.org, tglx@linutronix.de, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 04/17] workqueue: Replace hardcoding of -20 with MIN_NICE.
Message-ID: <20140311125529.GE11477@htj.dyndns.org>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
 <ff13819fd09b7a5dba5ab5ae797f2e7019bdfa17.1394532288.git.yangds.fnst@cn.fujitsu.com>
 <20140311122225.GB11477@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311122225.GB11477@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 08:22:25AM -0400, Tejun Heo wrote:
> On Tue, Mar 11, 2014 at 06:09:12PM +0800, Dongsheng Yang wrote:
> > Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> > cc: Tejun Heo <tj@kernel.org>
> 
> Applied to wq/for-3.15.

And reverted as MIN_NICE is not defined yet.  Please feel free to add
my Acked-by and route it together with the prerequisite changes.

Thanks.

-- 
tejun
