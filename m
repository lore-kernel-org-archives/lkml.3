Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaFMFbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:31:13 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58714 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaFMFbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:31:12 -0400
Date: Fri, 13 Jun 2014 08:31:07 +0300
From: Dan Aloni <dan@kernelim.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mm/sched/net: BUG when running simple code
Message-ID: <20140613053107.GA24200@gmail.com>
References: <539A6850.4090408@oracle.com>
 <20140613032754.GA20729@gmail.com>
 <539A77A1.60700@oracle.com>
 <20140613045555.GB20729@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613045555.GB20729@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 07:55:55AM +0300, Dan Aloni wrote:
> And also, the Oops code of 0003 (PF_WRITE and PF_USER) might hint at
> what Dave wrote.

Scrape what I wrote about that, it's PF_PROT | PF_WRITE.

-- 
Dan Aloni
