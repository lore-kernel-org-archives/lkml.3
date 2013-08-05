Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3HEPlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:41:40 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:43769 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HEPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:41:38 -0400
Date: Mon, 5 Aug 2013 12:41:30 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/9] perf kvm: split out tracepoints from record args
Message-ID: <20130805154130.GA3228@ghostprotocols.net>
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com>
 <1375473947-64285-5-git-send-email-dsahern@gmail.com>
 <51FF339B.4050500@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FF339B.4050500@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 05, 2013 at 01:09:47PM +0800, Xiao Guangrong escreveu:
> On 08/03/2013 04:05 AM, David Ahern wrote:
> > Needed by kvm live command. Make record_args a local while we are
> > messing with the args.
> 
> Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Merged up to this one, waiting for the rest with Xiao's comments
addressed,

- Arnaldo
