Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3CYMIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:08:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57391
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756585Ab3CYMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:08:12 -0400
Message-ID: <1364213284.5053.4.camel@laptop>
Subject: Re: [PATCH v5 0/2] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Date: Mon, 25 Mar 2013 13:08:04 +0100
In-Reply-To: <CAFTL4hwGBFHyrY-thvOPe=CvrPu-CoFN8AGq-p8xWEWs8EPqgg@mail.gmail.com>
References: <1363949499-3728-1-git-send-email-eranian@google.com>
	 <CAFTL4hwGBFHyrY-thvOPe=CvrPu-CoFN8AGq-p8xWEWs8EPqgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 14:54 +0100, Frederic Weisbecker wrote:
> And I have to say this patch is going to be very useful for the full
> dynticks tree. We are happy to get rid of that tick hook.

I'm sorry to have to disappoint, but the tick hook is still there ;-),
its just no longer used for counter rotation. Of course we have
multiple uses for the tick, what did you think :-)

