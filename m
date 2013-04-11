Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936383Ab3DKPUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:20:06 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:50657 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935771Ab3DKPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:20:03 -0400
Date: Thu, 11 Apr 2013 17:19:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks
 range
Message-ID: <20130411151956.GF15699@somewhere>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
 <1364398359-21990-5-git-send-email-fweisbec@gmail.com>
 <20130328074507.GC24433@gmail.com>
 <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com>
 <20130330091037.GA31743@gmail.com>
 <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 02:57:18PM +0000, Christoph Lameter wrote:
> I think we could simplify things quite a bit if we either
> 
> 1. Add any cpus specified with nohz_full/extended=xxx to
> rcu_nocb. No check is then necessary anymore.

Yeah in the long term we probably want that indeed.

Thanks.
