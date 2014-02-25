Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaBYLD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:03:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaBYLD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:03:28 -0500
Date: Tue, 25 Feb 2014 12:03:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
Message-ID: <20140225110323.GL9987@twins.programming.kicks-ass.net>
References: <5304F32A.4040907@oracle.com>
 <5305856F.3000109@linux.vnet.ibm.com>
 <53078241.3060201@oracle.com>
 <53080122.609@linux.vnet.ibm.com>
 <530ABB44.5000601@oracle.com>
 <530AD653.3000808@linux.vnet.ibm.com>
 <20140224071028.GW9987@twins.programming.kicks-ass.net>
 <530B1B80.4000307@linux.vnet.ibm.com>
 <20140224121218.GR15586@twins.programming.kicks-ass.net>
 <530B8DBC.6020105@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B8DBC.6020105@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 01:21:48PM -0500, Sasha Levin wrote:
> Sign me up to the fan club of this patch, I love it.

I've converted that in a Tested-by: tag :-)
