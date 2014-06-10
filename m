Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaFJOFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:05:39 -0400
Received: from skprod3.natinst.com ([130.164.80.24]:60450 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752435AbaFJOFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:05:34 -0400
From: "Brad Mouring" <bmouring@ni.com>
Date: Tue, 10 Jun 2014 09:04:48 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 2/7] rtmutex: Clarify the boost/deboost part
Message-ID: <20140610140448.GB28502@linuxgetsreal>
References: <20140609201118.387571774@linutronix.de>
 <20140609202336.068962483@linutronix.de>
MIME-Version: 1.0
In-Reply-To: <20140609202336.068962483@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 09:04:49 AM,
	Serialize by Router on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/10/2014 09:04:49 AM,
	Serialize complete at 06/10/2014 09:04:49 AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_05:2014-06-10,2014-06-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 08:28:07PM -0000, Thomas Gleixner wrote:
> Add a separate local variable for the boost/deboost logic to make the
> code more readable. Add comments where appropriate.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

This would have made my life much easier these past few weeks.

Reviewed-by: Brad Mouring <brad.mouring@ni.com>
