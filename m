Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3FCNst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:48:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab3FCNsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:48:47 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=k3IMyhiXMLMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=XWLvF4f-614A:10 a=jZ9pT5ZhAAAA:8 a=VfT2EiVBJmujlCRffmIA:9 a=QEXdDO2ut3YA:10 a=BP2bKiBa3wEA:10 a=DuKptg00lN4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370267324.26799.88.camel@gandalf.local.home>
Subject: Re: [PATCH 2/8] vtime: Use consistent clocks among nohz accounting
From: Steven Rostedt <rostedt@goodmis.org>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>
Date: Mon, 03 Jun 2013 09:48:44 -0400
In-Reply-To: <51AC6625.3080000@message-id.invalid.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
	 <1369065716-22801-3-git-send-email-fweisbec@gmail.com>
	 <51AC6625.3080000@message-id.invalid.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 11:47 +0200, Stefan Seyfried wrote:

> FWIW:
> Tested-by: Stefan Seyfried <seife+dev@b1-systems.com>

FWIW, we can always use testers. Thanks for testing!

-- Steve


