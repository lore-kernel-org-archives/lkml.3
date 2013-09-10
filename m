Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3IJRd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:33:58 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42838 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3IJRd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:33:56 -0400
Date: Tue, 10 Sep 2013 02:39:16 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
In-Reply-To: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	(from cl@linux.com on Thu Sep  5 15:07:37 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1378798756.8385.24@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 03:07:37 PM, Christoph Lameter wrote:
> I am not sure how to call this kernel option but we need something  
> like
> that. I see drivers and the kernel spawning processes on the nohz  
> cores.
> The name kthread is not really catching the purpose.

Can't you just use the CPU affinity of PID 1 for this? Since it's a  
process that's always there and already has a mask and all. No need for  
a new interface...

Rob
