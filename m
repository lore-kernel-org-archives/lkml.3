Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaBODxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 22:53:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:34167 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaBODx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 22:53:29 -0500
Message-ID: <1392436208.10050.22.camel@pasglop>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Date: Sat, 15 Feb 2014 14:50:08 +1100
In-Reply-To: <20140214201908.082769265@linux.com>
References: <20140214201841.826179349@linux.com>
	 <20140214201908.082769265@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason Im still getting these as attachments instead of inline
in the email, which makes reviewing a major PITA. Christoph, I'm not
sure what you are doing wrong here but you should consider fixing it :-)

Cheers,
Ben.


