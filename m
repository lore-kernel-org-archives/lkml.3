Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaBGVz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:55:28 -0500
Received: from palahniuk.acksyn.org ([5.9.7.26]:60824 "EHLO
	palahniuk.acksyn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaBGVz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:55:27 -0500
Date: Fri, 7 Feb 2014 21:55:23 +0000
From: Michele Baldessari <michele@acksyn.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, trivial@kernel.org, chorn@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the arguments order of a few iscsi_conn_printk()
 calls
Message-ID: <20140207215523.GC25294@marquez.int.rhx>
References: <1391789933-15062-1-git-send-email-michele@acksyn.org>
 <52F54C04.4010807@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F54C04.4010807@cs.wisc.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, Feb 07, 2014 at 03:11:32PM -0600, Mike Christie wrote:
> On 02/07/2014 10:18 AM, Michele Baldessari wrote:
> > A few places had the opcode and itt arguments reversed.
> > Fix the order.
> > 
> > Reported-by: Josef Moellers <josef.moellers@ts.fujitsu.com>
> > Signed-off-by: Michele Baldessari <michele@acksyn.org>
> 
> 
> Thanks. I just acked a patch to do the same:
> https://lkml.org/lkml/2014/1/8/754

ah ok. Too many mailing lists and I did not see it in git master yet ;)
 
> Have you been hitting that code and with what target and what type of
> command?

I was made aware of it by a colleague who was looking at code. So no
real-life situation here.
 
regards,
Michele
-- 
Michele Baldessari            <michele@acksyn.org>
C2A5 9DA3 9961 4FFB E01B  D0BC DDD4 DCCB 7515 5C6D
