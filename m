Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3DKQOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:14:37 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40066 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3DKQOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:14:36 -0400
Date: Thu, 11 Apr 2013 09:05:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org, bp@alien8.de,
        arjan@linux.intel.com, khilman@linaro.org, cl@linux.com,
        pradeep@us.ibm.com
Subject: [PATCH documentation 0/2] OS-jitter documentation
Message-ID: <20130411160524.GA30384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041116-5806-0000-0000-000020B070AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This is v2 of the OS-jitter-reduction documentation.  Changes from
v1 (https://lkml.org/lkml/2013/3/18/462):

o	Updated the nohz1 patch based on feedback from Frederic Weisbecker,
	Steven Rostedt, Borislav Petkov, Arjan van de Ven, Kevin Hilman,
	and Christoph Lameter.

o	Added a second file describing how to reduce OS jitter from
	per-CPU kthreads.  This is quite rough, but is hopefully a
	good starting point.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/kernel-per-CPU-kthreads.txt |  159 ++++++++++++++++++
 b/Documentation/timers/NO_HZ.txt            |  245 ++++++++++++++++++++++++++++
 2 files changed, 404 insertions(+)

