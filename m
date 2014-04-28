Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaD1MAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:00:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36434 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaD1MAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:00:20 -0400
Date: Mon, 28 Apr 2014 14:59:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: micky_ching@realsil.com.cn, ulf.hansson@linaro.org, sameo@linux.intel.com,
        gregkh@linuxfoundation.org, linux-mmc@vger.kernel.org,
        chris@printf.net, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH] mmc: rtsx: Revert "mmc: rtsx: add support for pre_req
 and post_req"
Message-ID: <20140428115947.GA28139@mwanda>
References: <1398670584-26687-1-git-send-email-micky_ching@realsil.com.cn>
 <20140428105350.GM21279@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428105350.GM21279@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 11:53:50AM +0100, Lee Jones wrote:
> > From: Micky Ching <micky_ching@realsil.com.cn>
> > 
> > This reverts commit c42deffd5b53c9e583d83c7964854ede2f12410d.
> 
> Why was this patch even merged without an MFD Ack?

I think process questions like this are very important.

These patches touch both mmc and mfd but they're mostly mmc patches.

They were first sent to LKML in January.  Samuel was on the CC list but
you were left off.  There were no replies to the thread.  The patches
were then resent in February and Micky complained that they had been
sent "many times" and no one was responding.  So then Chris took them.

You should have been included on the CC list and Chris should have asked
you or Sam for a response explicitly instead of waiting for a month and
giving up.

Also Micky, please, when you do a new version of a patch please put an
explanation of what changed between version 3 and version 4.
http://kernelnewbies.org/PatchTipsAndTricks

regards,
dan carpenter

