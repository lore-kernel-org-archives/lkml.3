Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaFCPdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:33:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbaFCPdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:33:05 -0400
Date: Tue, 3 Jun 2014 17:32:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/13] perf tools: Add dso__data_* interface descriptons
Message-ID: <20140603153239.GI2864@krava.brq.redhat.com>
References: <1401743927-398-1-git-send-email-jolsa@kernel.org>
 <1401743927-398-10-git-send-email-jolsa@kernel.org>
 <538DD170.6040000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538DD170.6040000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 07:45:20AM -0600, David Ahern wrote:
> On 6/2/14, 3:18 PM, Jiri Olsa wrote:
> >Adding descriptions/explanations for dso__data_* interface
> >functions.
> 
> Shouldn't the descriptions be added when the functions are?

well, some of the described functions were already there,
so i thought it'd be better to put it there alltogether
with new ones..


jirka
