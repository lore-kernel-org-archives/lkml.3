Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783Ab3DPQmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:42:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53169 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069Ab3DPQmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:42:13 -0400
Date: Tue, 16 Apr 2013 09:40:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org, bp@alien8.de,
        arjan@linux.intel.com, khilman@linaro.org, cl@linux.com,
        peterz@infradead.org, tglx@linutronix.de, olivier.baetz@novasparks.com,
        rdunlap@infradead.org, zhong@linux.vnet.ibm.com, paulus@samba.org
Subject: PATCH documentation 0/2] OS-jitter documentation
Message-ID: <20130416164036.GA27246@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041616-7182-0000-0000-00000643ACC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This is v3 of the OS-jitter-reduction documentation.

Changes from v2 (https://lkml.org/lkml/2013/4/11/337 and
https://lkml.org/lkml/2013/4/11/338):

o	Updated both patches based on review feedback.

Changes from v1 (https://lkml.org/lkml/2013/3/18/462):

o	Updated the nohz1 patch based on feedback from Frederic Weisbecker,
	Steven Rostedt, Borislav Petkov, Arjan van de Ven, Kevin Hilman,
	and Christoph Lameter.

o	Added a second file describing how to reduce OS jitter from
	per-CPU kthreads.  This is quite rough, but is hopefully a
	good starting point.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/kernel-per-CPU-kthreads.txt |  186 ++++++++++++++++++++
 b/Documentation/timers/NO_HZ.txt            |  255 ++++++++++++++++++++++++++++
 2 files changed, 441 insertions(+)

