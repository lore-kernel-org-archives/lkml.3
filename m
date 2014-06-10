Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaFJN6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:58:12 -0400
Received: from skprod3.natinst.com ([130.164.80.24]:58151 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750945AbaFJN6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:58:11 -0400
From: "Brad Mouring" <bmouring@ni.com>
Date: Tue, 10 Jun 2014 08:57:21 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 1/7] rtmutex: Deobfuscate chain walk
Message-ID: <20140610135721.GA28502@linuxgetsreal>
References: <20140609201118.387571774@linutronix.de>
 <20140609202335.980283946@linutronix.de>
MIME-Version: 1.0
In-Reply-To: <20140609202335.980283946@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 08:57:22 AM,
	Serialize by Router on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 08:57:22 AM,
	Serialize complete at 06/10/2014 08:57:22 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_05:2014-06-10,2014-06-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 08:28:06PM -0000, Thomas Gleixner wrote:
> There is no point to keep the task ref across the check for lock
> owner. Drop the ref before that, so the protection context is clear.
> 
> Found while documenting the chain walk.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

I also am not a huge fan of the verbiage of the commit message here.
Steven's makes more sense to me, and you basically say the same thing
in the actual commit message.

Reviewed-by: Brad Mouring <brad.mouring@ni.com>
