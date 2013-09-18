Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3IRKSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:18:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39257 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3IRKSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:18:17 -0400
Date: Wed, 18 Sep 2013 12:18:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
Message-ID: <20130918101801.GO12926@twins.programming.kicks-ass.net>
References: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
 <20130918092444.GA2778@gmail.com>
 <CAPybu_2GBymhgxHmtJu63pT2t8ge84EA9Ww54r9mGOA5KH7Hww@mail.gmail.com>
 <CAPybu_2Wf_p-jo2X4VzSBXrfy3DnHY4PeOvNVLfeoGRFfbDwRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_2Wf_p-jo2X4VzSBXrfy3DnHY4PeOvNVLfeoGRFfbDwRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 12:02:12PM +0200, Ricardo Ribalda Delgado wrote:
> Hello again Ingo:
> 
> Perhaps this is even more clear than v2:
> 
> len = snprintf(file, size, "%s", symbol_conf.symfs);
> size -= len;
> file += len;
> len = snprintf(file, MIN(size,(last_slash - dso->long_name) + 2),
> "%s",  dso->long_name);
> size -= len;
> file += len;
> len = snprintf(file, size, ".debug%s",  last_slash);
> 

len = 0;

len += snprintf(str + len, size - len, ...);
len += snprintf(str + len, size - len, ...);


