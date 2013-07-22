Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab3GVKR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:17:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab3GVKR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:17:56 -0400
Date: Mon, 22 Jul 2013 12:17:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 22/23] perf tools: Add multi file '-M' option for record
 command
Message-ID: <20130722101738.GE14350@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-23-git-send-email-jolsa@redhat.com>
 <87txjqvh1q.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txjqvh1q.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 10:02:41PM +0900, Namhyung Kim wrote:
> On Wed, 17 Jul 2013 19:50:02 +0200, Jiri Olsa wrote:
> > Adding multi file '-M' option for record command to store
> > split event data into multiple files based on the file
> > size specified as an argument to the option.
> 
> It seems you need to update the doc too. :)

will do ;-)

thanks,
jirka
