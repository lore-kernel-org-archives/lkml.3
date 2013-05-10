Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3EJTYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:24:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab3EJTYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:24:21 -0400
Date: Fri, 10 May 2013 15:24:17 -0400
From: Dave Jones <davej@redhat.com>
To: akpm@linux-foundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: SyS symbol munging.
Message-ID: <20130510192417.GA4915@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 12:14:54PM -0700, Andrew Morton wrote:

 > [  163.953629] Call Trace:
 > [  163.957706]  [<ffffffff812be322>] ipcget+0x182/0x380
 > [  163.962123]  [<ffffffff810b99a5>] ?trace_hardirqs_on_caller+0x115/0x1e0
 > [  163.966752]  [<ffffffff812c559a>] SyS_shmget+0x5a/0x60
 > [  163.971163]  [<ffffffff812c47e0>] ? shm_close+0x140/0x140
 > [  163.975590]  [<ffffffff812c3e60>] ? shm_release+0x50/0x50
 > [  163.979991]  [<ffffffff812c3df0>] ? shm_get_unmapped_area+0x20/0x20
 > [  163.984499]  [<ffffffff816caa14>] tracesys+0xdd/0xe2
 
This has been bugging me for a while.
What's changing sys_shmget to SyS_shmget in that trace ? And why ?

	Dave

