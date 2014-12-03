Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaLCBK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:10:29 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55715 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCBK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:10:28 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 3 Dec 2014 10:13:53 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [mm] BUG: unable to handle kernel paging request at c2446ffc
Message-ID: <20141203011353.GA10084@js1304-P5Q-DELUXE>
References: <20141202043638.GB6268@js1304-P5Q-DELUXE>
 <20141202050417.GA10296@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202050417.GA10296@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:04:17PM -0800, Fengguang Wu wrote:
> > Hello, Fengguang.
> > 
> > First of all, thanks for reporting!
> > It always helps me a lot.
> > 
> > But, in this time, I can't reproduce this failure with your attached
> 
> Judging from the bisect log, it showed up once per 26 boots, so may
> not be easy to reproduce. The other bisect below looks easier to
> reproduce.
> 
> > configuration. Instead of this failure, sometimes, OOM happens in my
> > testing with your configuration. I don't know why it happens. :)
> 
> Yes, it's not really obvious how the change will be related to this BUG. 
> 
> > Could you have another configuration to trigger this bug?
> 
> Sure. Below is another bisect result.

Hello, Fengguang.

Great! I can reproduce the problem with you another bisect result.
Thanks a lot!
Will send the fix to Andrew.

Thanks.

