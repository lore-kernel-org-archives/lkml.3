Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaIHKcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:32:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25723 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaIHKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:32:32 -0400
Date: Mon, 8 Sep 2014 13:32:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Spencer Baugh <sbaugh@andrew.cmu.edu>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        gregkh@linuxfoundation.org, Hongchao Zhang <hongchao.zhang@intel.com>,
        Niu Yawei <yawei.niu@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: Re: [PATCH 2/3] staging: lustre: fix pointer whitespace style
Message-ID: <20140908103208.GK6600@mwanda>
References: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
 <1410025111-31422-2-git-send-email-sbaugh@andrew.cmu.edu>
 <1410027543.2723.8.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410027543.2723.8.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 11:19:03AM -0700, Joe Perches wrote:
> 
> Indexing a string array with an enum is generally unsafe.
> 
> I think it better to use a switch/case like:
> 

The reverse side of that argument is that switch statements are slower
and uglier.

My understanding is that according to the c spec, "state" could be
signed but in this case GCC defines it as unsigned int.  So the ASSERT
is ok in real life, but in theory it should check for negatives as well.

regards,
dan carpenter

