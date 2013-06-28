Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3F1QHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:07:07 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38940 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab3F1QHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:07:04 -0400
Date: Fri, 28 Jun 2013 21:36:50 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        pjt@google.com
Subject: Re: [patch based tip/sched/core] sched/debug: remove
 CONFIG_FAIR_GROUP_SCHED mask
Message-ID: <20130628160650.GA24565@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1372417835-4698-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1372417835-4698-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062815-0260-0000-0000-0000033C69D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Shi <alex.shi@intel.com> [2013-06-28 19:10:35]:

> Now we are using runnable load avg in sched balance. So don't need
> keep marking them under CONFIG_FAIR_GROUP_SCHED. Also align the code
> style to #ifdef instead of #if defined() and reorder the tg output info.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

