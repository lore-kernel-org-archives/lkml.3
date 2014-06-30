Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaF3IWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbaF3IWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:22:04 -0400
Date: Mon, 30 Jun 2014 09:21:44 +0100
From: Joe Thornber <thornber@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com,
        linux-kernel@vger.kernel.org, Minfei Huang <huangminfei@ucloud.cn>,
        linux-raid@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH] dm-io: Prevent the danging point of the sync
 io callback function
Message-ID: <20140630082143.GA3098@debian>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, Minfei Huang <huangminfei@ucloud.cn>,
	linux-raid@vger.kernel.org, agk@redhat.com
References: <1403841690-4401-1-git-send-email-huangminfei@ucloud.cn>
 <20140627151105.GA30592@debian>
 <alpine.LRH.2.02.1406271432430.18515@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1406271432430.18515@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 02:44:41PM -0400, Mikulas Patocka wrote:
> I suggest - split it to two patches, a minimal patch that fixes the bug by 
> changing sleeper to completion and the second patch with remaining changes 
> - so that only the first patch can be backported to stable kernels.

Agreed.  Thanks for reviewing.
